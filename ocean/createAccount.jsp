<!--input-->
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'admin';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<html>
  <head></head>
  <body>
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.FALSE;
      
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
      
      // Retrieving all the data from the parameters passed via POST from previous page.
      String user = request.getParameter("uid");
      String pw = request.getParameter("pass");
      String role = request.getParameter("role");
      Integer pid = Integer.parseInt(request.getParameter("pid"));
      String phone = request.getParameter("phone");
      String email = request.getParameter("email");
      String address = request.getParameter("address");
      String lname = request.getParameter("lname");
      String fname = request.getParameter("fname");
      
      // Get current date-time as at this moment is the time the new account was made.
      // taken from BalusC's answer http://stackoverflow.com/questions/5393824/passing-date-from-an-html-form-to-a-servlet-to-an-sql-database
      java.util.Date date = new java.util.Date();
      java.sql.Date date_reg = new java.sql.Date(date.getTime());

      // Create a new hashed password and its salt from the given plain text password.
      String digested = s.digest(pw);
      // substring's index begin is inclusive, and index end is exclusive.
      String hashed = digested.substring(32,64);
      String salt = digested.substring(0,32);
      
      // The queries to use in string format
      String queryPeople = "select person_id, first_name, last_name, address, email, phone from PERSONS";
      String queryUsers = "select USER_NAME, PASSWORD, ROLE, DATE_REGISTERED, PERSON_ID from USERS";
      String querySalts = "select USER_NAME, SALT from SALTS";
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      // Variable to store connection and statements and prepared statements.
      Connection mCon = null;
      Statement stmnt = null;
      PreparedStatement pstmnt = null;
      
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
      
      // actually log in and perform statements
      try {
          // create the connection
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          
          // create the statement
          stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          
	  
	  
          // execute query of getting the result set table in order to create a new row of person.
          ResultSet rset = stmnt.executeQuery(queryPeople);
          rset.moveToInsertRow();
          rset.updateInt(1,pid);
          rset.updateString(2,fname);
          rset.updateString(3,lname);
          rset.updateString(4,address);
          rset.updateString(5,email);
          rset.updateString(6,phone);
          
          rset.insertRow();
          
          // execute query of getting the result set table in order to create a new row of user.
          rset = stmnt.executeQuery(queryUsers);
          rset.moveToInsertRow();
          rset.updateString(1,user);
          rset.updateString(2,hashed);
          rset.updateString(3,role);
          rset.updateDate(4,date_reg);
          rset.updateInt(5,pid);

          rset.insertRow();
          
          // execute query of getting the result set table in order to create a new row user's salt.
          rset = stmnt.executeQuery(querySalts);
          rset.moveToInsertRow();
          rset.updateString(1,user);
          rset.updateString(2,salt);
          
          rset.insertRow();
          
          // query to check if new user made actually exists.
          pstmnt = mCon.prepareStatement("Select U.USER_NAME from USERS U, SALTS S where U.USER_NAME=? and U.USER_NAME=S.USER_NAME");
          pstmnt.setString(1,user);
          ResultSet rset2 = pstmnt.executeQuery();
          
          if(rset2.next()) {
            // new user inserted actually exists.
            out.println("The new user " + user + " was succesfully created. You will be redirected in 3 seconds");
            String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"usermanage.jsp\"; \',3000);</script>";
            out.println(redirectCode);
          } else {
            // new user does not exist.
            out.println("Something went wrong...<br>Failed to create the new user " + user + "." );
          }

      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("createAccount.jsp SQLException: " + ex.getMessage());
          out.println("Something went wrong...Please ensure your email and person id are unique<br>Failed to create the new user " + user + ".<br>You will be redirected in 3 seconds." );
          String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"usermanage.jsp\"; \',3000);</script>";
          out.println(redirectCode);
      } finally {
        // close the statements, the prepared statements, and the connection.
        if(stmnt != null) {
          stmnt.close();
        }
        if(pstmnt != null) {
          pstmnt.close();
        }
        if(mCon != null) {
          mCon.close();
        }
      }
    %>
  </div>
</div>
  </body>
</html>
