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
      String pw = request.getParameter("pass");
      Boolean validRow = Boolean.FALSE;
      String hashed = new String();
      String salt = new String();
	String role = new String();
	String pid = new String();
      
      /*
      String digested = s.digest(pw);
      out.println("<BR>DigestedPassword: " + digested);
      //plain: 12345
      //hash: 40E281FAFF055AC5A0C29085E331EE41
      //salt: 77EF8D175E18F5516BC266B79C517232
      String hash ="40E281FAFF055AC5A0C29085E331EE41";
      String salt ="77EF8D175E18F5516BC266B79C517232";
      out.println("<BR>hash matches pw?: " + s.matches(pw, salt+hash));
      */
  
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      Connection mCon;
      PreparedStatement pstmt;
	  PreparedStatement pstmt2;
      
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
          pstmt = mCon.prepareStatement("select U.USER_NAME, U.PASSWORD, U.ROLE, U.PERSON_ID, S.SALT from USERS U, SALTS S where U.USER_NAME=? and U.USER_NAME=S.USER_NAME");

          pstmt.setString(1,user);

          ResultSet rset = pstmt.executeQuery();
          validRow = rset.next();
         
          hashed = rset.getString("PASSWORD");
          salt = rset.getString("SALT");
          role = rset.getString("ROLE");
	  pid = rset.getString("PERSON_ID");
          pstmt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }
      
          
          Boolean goodPassword = Boolean.FALSE;
          if(validRow)
            goodPassword = Boolean.valueOf(s.matches(pw, salt+hashed));
          
          if(validRow && goodPassword) {
              out.println("Welcome " + user + "!");
              // taken from http://www.pa.msu.edu/services/computing/faq/auto-redirect.html
              String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">document.cookie = 'name=" + user + ";';document.cookie = 'role=" + role + ";';document.cookie = 'pid=" + pid + ";';document.cookie = 'path=/;';document.cookie = 'domain=.cs.ualberta.ca;';window.setTimeout(\'window.location=\"landing.html\"; \',1500);</script>";
              out.println(redirectCode);
          } else {
              out.println("<br>Failed to log in: Wrong username or password.<br><button onclick='goBack()'>Try again</button><script>function goBack() {window.history.back();}</script>");
          }
      
    %>
  
  </body>
</html>
