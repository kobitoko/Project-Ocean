<!--input-->
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'admin';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
  <body>
<div>
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.TRUE;
      
      // Retrieving all the data from the parameters passed via POST from previous page.
      String user = request.getParameter("userToDelete");
      // potentially not safe if someone modifies the options in the list and passes a modified option to this jsp.
      String queryDelUsr = "select USER_NAME from USERS where USER_NAME=\'" + user +"\'";
      String queryDelSalt = "select USER_NAME from SALTS where USER_NAME=\'" + user +"\'";
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      // Variable to store connection and statements.
      Connection mCon;
      Statement stmnt;
      
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
        try{
            // create the connection
            mCon = DriverManager.getConnection(mUrl, mUser, mPass);
            
            // create the statement
            stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            
            // Remove first those who depend on the foreign primary key USER_NAME, which is salts.
            ResultSet rset = stmnt.executeQuery(queryDelSalt);
            if(rset.next()) {
            rset.absolute(1);
            rset.deleteRow();
            
            // Actually remove the user.
            rset = stmnt.executeQuery(queryDelUsr);
            rset.absolute(1);
            rset.deleteRow();

            // Show success of removal, returns to usermanage.jsp.
            out.println("The user " + user + " was removed. You will be redirected in 3 seconds.  ");
	String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"usermanage.jsp\"; \',3000);</script>";
              out.println(redirectCode);
          } else {
            // Show that removal went wrong, because that user specified doesn't exist.
            out.println("Something went wrong.");  
          }
          
          // close the statements, and the connection.
          stmnt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
    %>
  </div>
</div>
  </body>
</html>
