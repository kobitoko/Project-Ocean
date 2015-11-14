<!--input-->
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<html>
  <head></head>
  <body>
    <%
    
      Boolean debug = Boolean.TRUE;
      
      //MD5 + Salting
      StandardStringDigester s;
        
      // Initialize the digestor
      s = new StandardStringDigester();
      
      // because MD5 is within 32 varchar limit.
      s.setAlgorithm("MD5");

      s.setIterations(999);

      // For the delicious salt: by default an instance of RandomSaltGenerator will be used.
      // Raw random salt gets prepended in jasypt, each byte is 2 string chars in hex. 
      s.setSaltSizeBytes(16);

      // default is base64, but want hex.
      s.setStringOutputType("hexadecimal");

      s.initialize();
      
      // Get this user with the old userID and old PID to find the user in the first place. 
      String oldUser = request.getParameter("ouid");
      Integer oldPID = Integer.parseInt(request.getParameter("opid"));
      
      String uid = request.getParameter("uid");
      String role = request.getParameter("newrole");
      String fname = request.getParameter("fname");
      String lname = request.getParameter("lname");
      String address = request.getParameter("address");
      String email = request.getParameter("email");
      String oldEmail = new String();
      String phone = request.getParameter("phone");
      Integer personId = Integer.parseInt(request.getParameter("pid"));
      String newPass = request.getParameter("pass");
      
      // initialize with default password "admin"
      String hashed = "4CF49155816C245A106D80D64123BAE9";
      String salt = "A48E8B18189B4FB6691A56E1575D2280";
      
      if(!newPass.isEmpty()) {
        String digested = s.digest(newPass);
        // substring's index begin is inclusive, and index end is exclusive.
        hashed = digested.substring(32,64);
        salt = digested.substring(0,32);
      }
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      // instantiate the driver.
      try {
          Class drvClass = Class.forName(mDriverName);
          DriverManager.registerDriver((Driver) drvClass.newInstance());
      } catch(Exception e) {
          System.err.print("ClassNotFoundException: ");
          System.err.print(e.getMessage());
          if(debug)
            out.println("<BR>-debugLog: Received a ClassNotFoundException: " + e.getMessage());
      }
      
      Connection mCon = null;
      Boolean oldAutoCommitVal = Boolean.TRUE;
      
      PreparedStatement checkUserIdExists = null;
      PreparedStatement insertPersons = null;
      PreparedStatement emailUpdate = null;
      PreparedStatement updateUserId = null;
      PreparedStatement updateSaltsUid = null;
      PreparedStatement updatePassword = null;
      PreparedStatement updateSalt = null;
      
      // actually log in and perform statements
      try{              
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        oldAutoCommitVal = mCon.getAutoCommit();
        mCon.setAutoCommit(Boolean.FALSE);
        
        // if this returns a table with 1 row, that new username is invalid!
        checkUserIdExists = mCon.prepareStatement("select USER_NAME from USERS where USER_NAME=? AND USER_NAME<>?");
        checkUserIdExists.setString(1, uid);
        checkUserIdExists.setString(2, oldUser);
        ResultSet rset = checkUserIdExists.executeQuery();
        if(rset.next()) {
          // Notify user that the new user name is already taken! And go back to previous page.
          checkUserIdExists.close();
          out.println("Your new username: " + uid + " already exists! \n Try again please.");
          System.err.println("New USER_NAME already exists!");
        } else if (!rset.next()) {
          // New username is unique and ok to be used.
          
          // Password hash and salt will be set to original if no new password.
          if(newPass.isEmpty()) {              
              // get old password, salt, and email
              updatePassword = mCon.prepareStatement("select U.PASSWORD, S.SALT, P.email from USERS U, SALTS S, PERSONS P where U.USER_NAME=S.USER_NAME and P.PERSON_ID=U.PERSON_ID and U.USER_NAME=?");
              updatePassword.setString(1, oldUser);
              ResultSet getOldInfo = updatePassword.executeQuery();
              
              getOldInfo.next();
              hashed = getOldInfo.getString(1);
              salt = getOldInfo.getString(2);
              oldEmail = getOldInfo.getString(3);
          }
          // Update salt
          updateSalt = mCon.prepareStatement("UPDATE SALTS set SALT=? where USER_NAME=?");
          updateSalt.setString(1, salt);
          updateSalt.setString(2, oldUser);
          updateSalt.executeUpdate();
          
          // Update keys using the wihtin transaction method taken from http://stackoverflow.com/questions/2877540/is-it-possible-to-modify-the-value-of-a-records-primary-key-in-oracle-when-chil
          // Update the personID key.
          if(!oldPID.equals(personId)) {
            // a new pid is provided.
            insertPersons = mCon.prepareStatement("INSERT INTO PERSONS (first_name, last_name, address, phone, person_id) VALUES (?, ?, ?, ?, ?)");
          } else {
            // no new pid
            insertPersons = mCon.prepareStatement("UPDATE PERSONS SET first_name=?, last_name=?, address=?, phone=? WHERE person_id=?");
          }
          insertPersons.setString(1, fname);
          insertPersons.setString(2, lname);
          insertPersons.setString(3, address);
          insertPersons.setString(4, phone);
          insertPersons.setInt(5,personId);
          insertPersons.executeUpdate();
          
          // update the userId only if changed, but other than userId still updates that users data.
          if(oldUser.equals(uid)) {
            // no userID change
            updateUserId = mCon.prepareStatement("UPDATE USERS set PASSWORD=?, ROLE=?, PERSON_ID=? where USER_NAME=?");
            updateUserId.setString(1, hashed);
            updateUserId.setString(2, role);
            updateUserId.setInt(3, personId);
            updateUserId.setString(4, oldUser);
            updateUserId.executeUpdate();
          } else {
            // userID is changing too.
            updateUserId = mCon.prepareStatement("INSERT INTO USERS (USER_NAME, PASSWORD, ROLE, PERSON_ID, DATE_REGISTERED ) SELECT ?, ?, ?, ?, DATE_REGISTERED from USERS where USER_NAME=?");
            updateUserId.setString(1, uid);
            updateUserId.setString(2, hashed);
            updateUserId.setString(3, role);
            updateUserId.setInt(4, personId);
            updateUserId.setString(5, oldUser);
            updateUserId.executeUpdate();
            
            // update the salts table with new userId
            updateSaltsUid = mCon.prepareStatement("UPDATE SALTS set USER_NAME=? where USER_NAME=?");
            updateSaltsUid.setString(1, uid);
            updateSaltsUid.setString(2, oldUser);
            updateSaltsUid.executeUpdate();
            
            // Remove old userID 
            PreparedStatement delOldUsr = mCon.prepareStatement("DELETE FROM USERS where USER_NAME=?");
            delOldUsr.setString(1, oldUser);
            delOldUsr.executeUpdate();
            delOldUsr.close();
          }
          
          // Remove old personId row only when pid changed.
          if(!oldPID.equals(personId)) {
            PreparedStatement delOldPerson = mCon.prepareStatement("DELETE FROM PERSONS where PERSON_ID=?");
            delOldPerson.setString(1, oldPID.toString());
            delOldPerson.executeUpdate();
            delOldPerson.close();
          }
          
          // Email unique constraint. If changed: update it, and also update when an insert due 
          // to new pid copy because email unique constraint, otherwise email would be empty.
          if(oldEmail == null || !oldEmail.equals(email) || !oldPID.equals(personId)) {
            emailUpdate = mCon.prepareStatement("UPDATE PERSONS SET email=? WHERE person_id=?");
            emailUpdate.setString(1, email);
            emailUpdate.setInt(2, personId);
            emailUpdate.executeUpdate();
          }
          
          // Save all changes.
          mCon.commit();
        }
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          // something went wrong thus roll back.
          mCon.rollback();
      } finally {
        // In case of exceptions etc. this will always run, and shut down connection of SQL properly.
        
        mCon.setAutoCommit(oldAutoCommitVal);
        
        if(insertPersons != null) {
          insertPersons.close();
        }
        if(updateUserId != null) {
          updateUserId.close();
        }
        if(updateSaltsUid != null) {
          updateSaltsUid.close();
        }
        if(updateSalt != null) {
          updateSalt.close();
        }
        if(emailUpdate != null) {
          emailUpdate.close();
        }
        if(updatePassword != null) {
          updatePassword.close();
        }
        if(checkUserIdExists != null) {
          checkUserIdExists.close();
        }
        if(mCon != null) {
          mCon.close();
        }
      }
    %>
  
  </body>
</html>
