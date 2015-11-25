<!--input-->
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<html>
  <head></head>
  <body style="background:lightblue;">
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.TRUE;
      
      // The digester to create the hash from the input.
      StandardStringDigester s;
        
      // Initialize the digestor
      s = new StandardStringDigester();
      
      // because MD5 is within 32 varchar limit.
      s.setAlgorithm("MD5");

      // Apply the hash function this many times.
      s.setIterations(999);

      // For the delicious salt: by default an instance of RandomSaltGenerator will be used.
      // Raw random salt gets prepended in jasypt, each byte is 2 string chars in hex. 
      s.setSaltSizeBytes(16);

      // default is base64, but want hex.
      s.setStringOutputType("hexadecimal");

      s.initialize();
      
      // Get this user with the old userID and old PID to find the user in the first place. 
      String oldUser = null;
      Integer oldPID = null;
      // Retrieve the old user and old pid from the cookie.
        //Based on tutorials at http://www.tutorialspoint.com/
        Cookie cookie = null;
        Cookie[] cookies = null;
        String comppid = "modpid";
        String compname = "modname";
        cookies = request.getCookies();
           if( cookies != null ){
             for (Integer i = 0; i < cookies.length; i++){
                 	cookie = cookies[i];
	
	            if(cookie.getName().equals(comppid)){oldPID = Integer.parseInt(cookie.getValue());}
	            if(cookie.getName().equals(compname)){oldUser = cookie.getValue();}
            }
          }

      // Retrieving all the data from the parameters passed via POST from previous page.
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
      
      // initialize with default hashed password and the salt of "admin"
      String hashed = "4CF49155816C245A106D80D64123BAE9";
      String salt = "A48E8B18189B4FB6691A56E1575D2280";
      
      // Only create a new hashed password and its salt if the new password field was not empty.
      if(!newPass.isEmpty()) {
        String digested = s.digest(newPass);
        // substring's index begin is inclusive, and index end is exclusive.
        hashed = digested.substring(32,64);
        salt = digested.substring(0,32);
      }
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "TRY HARDER";
      String mPass = "TRY HARDER";
      
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
      
      // Variable to store connection and prepared statements.
      Connection mCon = null;
      Boolean oldAutoCommitVal = Boolean.TRUE;
      
      PreparedStatement checkUserIdExists = null;
      PreparedStatement insertPersons = null;
      PreparedStatement emailUpdate = null;
      PreparedStatement updateUserId = null;
      PreparedStatement updateSaltsUid = null;
      PreparedStatement updatePassword = null;
      PreparedStatement updateSalt = null;
      Statement stmtUpPids = null;
      ResultSet rsetUpPids = null;
      
      // actually log in and perform statements
      try{          
        // create the connection
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        
        // disable autocommit.
        oldAutoCommitVal = mCon.getAutoCommit();
        mCon.setAutoCommit(Boolean.FALSE);
        
        boolean validNewPid = false;
        
        // if this returns a table with 1 row, that new personId is invalid, as it aleady exist.
        checkUserIdExists = mCon.prepareStatement("select person_id from persons where person_id=? AND person_id<>?");
        checkUserIdExists.setInt(1, personId);
        checkUserIdExists.setInt(2, oldPID);
        ResultSet rset = checkUserIdExists.executeQuery();
        if(rset.next()) {
          // Notify user that the new user name is already taken! And go back to previous page.
          checkUserIdExists.close();
          out.println("Your new pid: " + personId + " already exists! \n Try another value please. You will be redirected in 3 seconds.");
          
          String redirc = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\"window.history.back()\",3000);</script>";
          out.println(redirc);
          
          System.err.println("New PID already exists!");
        } else {
          // if this returns a table with 1 row, that new username is invalid, as it aleady exist.
          checkUserIdExists = mCon.prepareStatement("select USER_NAME from USERS where USER_NAME=? AND USER_NAME<>?");
          checkUserIdExists.setString(1, uid);
          checkUserIdExists.setString(2, oldUser);
          rset = checkUserIdExists.executeQuery();
          if(rset.next()) {
            // Notify user that the new user name is already taken! And go back to previous page.
            checkUserIdExists.close();
            out.println("Your new username: " + uid + " already exists! \n Try again please. You will be redirected in 3 seconds.");
            
            String redircode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\"window.history.back()\",3000);</script>";
            out.println(redircode);
            
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
            
              // update all the user accounts with the old PersonID!
              String strUpdatePids = "Select person_id from users where person_id=\'" + oldPID + "\'";
              stmtUpPids = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
              rsetUpPids = stmtUpPids.executeQuery(strUpdatePids);

              // Iterate through all the pids and update them.
              while(rsetUpPids.next()) {
                rsetUpPids.updateInt(1, personId);
                rsetUpPids.updateRow();
              }
            
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
            
            // Show success of modification, returns to usermanage.jsp.
            out.println("Information for " + uid + " were succesfully changed. You will be redirected in 3 seconds");
            String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"usermanage.jsp\"; \',3000);</script>";
            out.println(redirectCode);
            
          }
        }
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          // something went wrong thus roll back.
          mCon.rollback();
      } finally {
        // In case of exceptions etc. this will always run, and shut down connection of SQL properly.
        
        // set the connection back to the previous value of the autocommit, which is probably Boolean.TRUE.
        mCon.setAutoCommit(oldAutoCommitVal);
        // close the result set table, the statements, the prepared statements, and the connection.
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
        if(stmtUpPids != null) {
          stmtUpPids.close();
        }
        if(rsetUpPids != null) {
          rsetUpPids.close();
        }
        if(mCon != null) {
          mCon.close();
        }
      }
    %>
  
  </body>
</html>
