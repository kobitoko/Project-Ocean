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
      
      /*
        the following data got from the previous page:
        name="uid" Username
        name="fname" First Name
        name="lname" Last Name
        name="address" Address
        name="email" email
        name="phone" phone
        name="pid     personId
        name="pass"  newPassword
      */
      
      // Get this user with the old userID to find the user in the first place. 
      String oldUser = request.getParameter("OLD_USERID");
      
      String uid = request.getParameter("uid");
      String fname = request.getParameter("fname");
      String lname = request.getParameter("lname");
      String address = request.getParameter("address");
      String email = request.getParameter("email");
      // phone is char(10) in persons table.
      String phone = request.getParameter("phone");
      String personId = request.getParameter("pid");
      String newPass = request.getParameter("pass");
      
      String digested = s.digest(newPass);
      // substring's index begin is inclusive, and index end is exclusive.
      String hashed = digested.substring(32,64);
      String salt = digested.substring(0,32);
      
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
      PreparedStatement updateUserId;
      PreparedStatement updateSaltsUid;
      
      // this line here update userId from person table
      PreparedStatement updatePassword;
      PreparedStatement updateSaltsSalt;
      
      // actually log in and perform statements
      try{              
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        
        // if this returns a table with 1 row, that new username is invalid!
        checkUserIdExists = mCon.prepareStatment("select USER_NAME from USERS where USER_NAME=?");
        checkUserIdExists.setString(1, uid);
        checkUserIdExists.setString(1, uid);
        
        ResultSet rset = checkUserIdExists.executeQuery();
        if(rset.next()) {
          //Notify user that the new user name is already taken! And go back to previous page.
          
        } else if (!rset.next()) {
        
          updatePassword = mCon.prepareStatment("update USERS set PASSWORD=? where USER_NAME=?", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          updatePassword.setString(1, hashed);
          updatePassword.setString(2, oldUser);
          
          updateSaltsSalt = mCon.prepareStatment("update SALTS set SALT=? where USER_NAME=?", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          updateSaltsSalt.setString(1, salt)
          updateSaltsSalt.setString(2, oldUser);
          
          // TODO: when people table is done, make info there updatable as well!!!!
          
          // Do this last, so you can use the old USER_NAME above.
          updateUserId = mCon.prepareStatment("update USERS set USER_NAME=? where USER_NAME=?", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          updateUserId.setString(1, uid);
          updateUserId.setString(2, oldUser);
          
          updateSaltsUid = mCon.prepareStatment("update SALTS set USER_NAME=? where USER_NAME=?", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          updateSaltsUid.setString(1, uid);
          updateSaltsUid.setString(2, oldUser);
          
          // Do prepareStatment that commits data!?
          // no according to http://stackoverflow.com/questions/10814913/sql-preparedstatement-autocommit
          // but ResultSet.TYPE_SCROLL_SENSITIVE and CONCUR_UPDATABLE should make it? or is only for the rest created from that sql statement??
          if(!mCon.getAutoCommit()) {
            mCon.commit();
          }
          
        }
      
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
    %>
  
  </body>
</html>
