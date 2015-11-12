<!--input-->
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<html>
  <head></head>
  <body>
    <%
      
      Boolean debug = Boolean.TRUE;
      
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
      
      String user = request.getParameter("uid");
      String pw = request.getParameter("password");
      String role = request.getParameter("role");
      Integer pid = Integer.parseInt(request.getParameter("pid"));
      String phone = request.getParameter("phone");
      String email = request.getParameter("email");
      String address = request.getParameter("address");
      String lname = request.getParameter("lname");
      String fname = request.getParameter("fname");
      
      // taken from BalusC's answer http://stackoverflow.com/questions/5393824/passing-date-from-an-html-form-to-a-servlet-to-an-sql-database
      java.util.Date date = new java.util.Date();
      java.sql.Date date_reg = new java.sql.Date(date.getTime());

      String digested = s.digest(pw);
      // substring's index begin is inclusive, and index end is exclusive.
      String hashed = digested.substring(32,64);
      String salt = digested.substring(0,32);
      
      String queryPeople = "select person_id, first_name, last_name, address, email, phone from PERSONS";
      String queryUsers = "select USER_NAME, PASSWORD, ROLE, DATE_REGISTERED, PERSON_ID from USERS";
      String querySalts = "select USER_NAME, SALT from SALTS";
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      Connection mCon;
      Statement stmnt;
      PreparedStatement pstmnt;
      
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
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          
          ResultSet rset = stmnt.executeQuery(queryPeople);
          rset.moveToInsertRow();
          out.println("before1");
          rset.updateInt(1,pid);
          out.println("Not int 1");
          rset.updateString(2,fname);
          rset.updateString(3,lname);
          rset.updateString(4,address);
          rset.updateString(5,email);
          rset.updateString(6,phone);
          
          rset.insertRow();
          
          rset = stmnt.executeQuery(queryUsers);
          rset.moveToInsertRow();
          rset.updateString(1,user);
          rset.updateString(2,hashed);
          rset.updateString(3,role);
          rset.updateDate(4,date_reg);
          out.println("before2" );
          rset.updateInt(5,pid);
          out.println("Not int 2" );

          rset.insertRow();
          
          rset = stmnt.executeQuery(querySalts);
          rset.moveToInsertRow();
          rset.updateString(1,user);
          rset.updateString(2,salt);
          
          rset.insertRow();
          
          pstmnt = mCon.prepareStatement("Select U.USER_NAME from USERS U, SALTS S where U.USER_NAME=? and U.USER_NAME=S.USER_NAME");
          pstmnt.setString(1,user);
          ResultSet rset2 = pstmnt.executeQuery();
          
          if(rset2.next()) {
            out.println("The new user " + user + " was succesfully created.");
          } else {
            out.println("Something went wrong...<br>Failed to create the new user " + user + "." );
          }

          stmnt.close();
          pstmnt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
    %>
  
  </body>
</html>
