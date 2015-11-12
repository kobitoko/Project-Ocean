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
      
      // Get this user with the old userID to find the user in the first place. 
      String oldUser = request.getParameter("ouid");
      
      // for some reason opod is NULL, but foudn other way to get it.
      //Integer oldPID = Integer.parseInt(request.getParameter("opid"));
      Integer oldPID = -1;
      
      String uid = request.getParameter("uid");
      String role = request.getParameter("role");
      String fname = request.getParameter("fname");
      String lname = request.getParameter("lname");
      String address = request.getParameter("address");
      String email = request.getParameter("email");
      // phone is char(10) in persons table.
      String phone = request.getParameter("phone");
      Integer personId = Integer.parseInt(request.getParameter("pid"));
      String newPass = request.getParameter("pass");
      
      // default password is "admin"
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
      
      Connection mCon;
      
      PreparedStatement checkUserIdExists;
      PreparedStatement getOldPid;
      PreparedStatement updatePersons;
      PreparedStatement updateUserId;
      PreparedStatement updateSaltsUid;
      PreparedStatement updatePassword;
      PreparedStatement updateSaltsSalt;
      
      // actually log in and perform statements
      try{              
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        Boolean oldAutoCommitVal = mCon.getAutoCommit();
        mCon.setAutoCommit(Boolean.FALSE);
        
        // if this returns a table with 1 row, that new username is invalid!
        checkUserIdExists = mCon.prepareStatement("select USER_NAME from USERS where USER_NAME=?");
        checkUserIdExists.setString(1, uid);
        
        ResultSet rset = checkUserIdExists.executeQuery();
        if(rset.next()) {
          //Notify user that the new user name is already taken! And go back to previous page.
          
        } else if (!rset.next()) {
              
          getOldPid = mCon.prepareStatement("select PERSON_ID from USERS where USER_NAME=?");
          getOldPid.setString(1,oldUser);
          ResultSet rset2 = getOldPid.executeQuery();
          if(rset.next()) {
            oldPID = rset.getInt("PERSON_ID"); 
          } else {
            //something went wrong!
          }
              
          updatePersons = mCon.prepareStatement("UPDATE PERSONS set PERSON_ID=?, FIRST_NAME=?, LAST_NAME=?, ADDRESS=?, EMAIL=?, PHONE=? where PERSON_ID=?");
          updatePersons.setInt(1,personId);
          updatePersons.setString(2, fname);
          updatePersons.setString(3, lname);
          updatePersons.setString(4, address);
          updatePersons.setString(5, email);
          updatePersons.setString(6, phone);
          updatePersons.setInt(7, oldPID);
          updatePersons.executeUpdate();
          updatePersons.close();
        
          updateUserId = mCon.prepareStatement("UPDATE USERS set USER_NAME=?, ROLE=?, PERSON_ID=? where USER_NAME=?");
          updateUserId.setString(1, uid);
          updateUserId.setString(2, role);
          updateUserId.setInt(3, personId);
          updateUserId.setString(4, oldUser);
          updateUserId.executeUpdate();
          updateUserId.close();
          
          updateSaltsUid = mCon.prepareStatement("UPDATE SALTS set USER_NAME=? where USER_NAME=?");
          updateSaltsUid.setString(1, uid);
          updateSaltsUid.setString(2, oldUser);
          updateSaltsUid.executeUpdate();
          updateSaltsUid.close();
        
          if(!newPass.isEmpty()) {
              updatePassword = mCon.prepareStatement("UPDATE USERS set PASSWORD=? where USER_NAME=?");
              updatePassword.setString(1, hashed);
              updatePassword.setString(2, uid);
              updatePassword.executeUpdate();
              updatePassword.close();
              
              updateSaltsSalt = mCon.prepareStatement("UPDATE SALTS set SALT=? where USER_NAME=?");
              updateSaltsSalt.setString(1, salt);
              updateSaltsSalt.setString(2, uid);
              updateSaltsSalt.executeUpdate();
              updateSaltsSalt.close();
          }
          
          // Do prepareStatment that commits data!?
          // no according to http://stackoverflow.com/questions/10814913/sql-preparedstatement-autocommit
          // but ResultSet.TYPE_SCROLL_SENSITIVE and CONCUR_UPDATABLE should make it? or is only for the rest created from that sql statement??
          mCon.commit();
          // aaaaaaa https://docs.oracle.com/javase/tutorial/jdbc/basics/transactions.html
          System.err.println(mCon.getAutoCommit());
          
          mCon.setAutoCommit(oldAutoCommitVal);
          
          System.err.println(mCon.getAutoCommit());
          
        }
        checkUserIdExists.close();
        mCon.close();
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
    %>
  
  </body>
</html>
