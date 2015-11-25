<!--input-->
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<%@ page import="java.util.*, java.sql.*"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Ocean Observation System</title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script src="analyzeSensor.js"></script>
<script>permission = 'loggedout';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
 <div id='content'>
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.FALSE;
      
      // The digester to create the hash from the input.
      StandardStringDigester s;
        
      // Initialize the digestor
      s = new StandardStringDigester();
      
      // because MD5 is within 32 varchar limit.
      s.setAlgorithm("MD5");

      s.setIterations(999);

      // For the delicious salt: by default an instance of RandomSaltGenerator will be used.
      // Raw random salt gets prepended in jasypt, each byte is 2 string chars in hex. 
      s.setSaltSizeBytes(16);

      // Default is base64, but want hex.
      s.setStringOutputType("hexadecimal");

      // Makes the digester ready to digest some plain texts into hashed format.
      s.initialize();
      
      // Retrieving all the parameters passed via POST from previous page.
      String user = request.getParameter("uid");
      String pw = request.getParameter("pass");
      
      // Stores the Boolean whether the row in the result set table is valid or not.
      Boolean validRow = Boolean.FALSE;
      // The hashed password
      String hashed = new String();
      // The password's salt for the hash
      String salt = new String();
      // To store the role of the user.
      String role = new String();
      // To store the person_id of the user.
      String pid = new String();
  
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "TRY HARDER";
      String mPass = "TRY HARDER";
      
      // Variable to store connection and prepared statements
      Connection mCon = null;
      PreparedStatement pstmt = null;
      PreparedStatement pstmt2 = null;
      
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
          // Create a connection
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          // prepare the statement to retrieve Users and Salts to compare to inputted hash.
          pstmt = mCon.prepareStatement("select U.USER_NAME, U.PASSWORD, U.ROLE, U.PERSON_ID, S.SALT from USERS U, SALTS S where U.USER_NAME=? and U.USER_NAME=S.USER_NAME");
          pstmt.setString(1,user);

          // Retrieve the result table.
          ResultSet rset = pstmt.executeQuery();
          validRow = rset.next();
         
          // Retrieve info from the result table into local variables.
          hashed = rset.getString("PASSWORD");
          salt = rset.getString("SALT");
          role = rset.getString("ROLE");
          pid = rset.getString("PERSON_ID");
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      } finally {
          // Close the prepared statement and connection
          pstmt.close();
          mCon.close();
      }
      
      // Set default that password don't match
      Boolean goodPassword = Boolean.FALSE;
      // If result table has the user, the user exist, compare password hashes.
      if(validRow)
        goodPassword = Boolean.valueOf(s.matches(pw, salt+hashed));
      
      if(validRow && goodPassword) {
          // The password hash matched the stored hash, stores then the appropriate cookies.
          out.println("Welcome " + user + "!");
          // taken from http://www.pa.msu.edu/services/computing/faq/auto-redirect.html
          String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">document.cookie = 'name=" + user + ";';document.cookie = 'role=" + role + ";';document.cookie = 'pid=" + pid + ";';document.cookie = 'path=/;';document.cookie = 'domain=.cs.ualberta.ca;';window.setTimeout(\'window.location=\"landing.html\"; \',1500);</script>";
          out.println(redirectCode);
      } else {
          // The password hash did NOT match the stored hash. Displays error message.
          out.println("<br>Failed to log in: Wrong username or password.<br><button onclick='goBack()'>Try again</button><script>function goBack() {window.history.back();}</script>");
      }
      
    %>
  </div>
</div>
  </body>
</html>
