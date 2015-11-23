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
      
      String pid = "";
      String queryDelUsr = "select USER_NAME, person_id from USERS where USER_NAME=\'" + user +"\'";
      String queryDelSalt = "select USER_NAME from SALTS where USER_NAME=\'" + user +"\'";
      String queryOnlyUserOfPerson ="";
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      // Variable to store result set table, connection, and statements.
      ResultSet rset = null;
      ResultSet rset2 = null;
      Connection mCon = null;
      Statement stmnt = null;
      Statement stmnt2 = null;
      
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
            rset = stmnt.executeQuery(queryDelSalt);
            if(rset.next()) {
              rset.deleteRow();
            
            // Actually remove the user.
            rset = stmnt.executeQuery(queryDelUsr);
            if(rset.next()) {
              pid = rset.getString(2);
              rset.deleteRow();
            }
            
            // check if no more user accounts exists for that persons, if so: remove them.
            // a bit redundant query but safer to me imo.
            queryOnlyUserOfPerson = "select u.USER_NAME from USERS u, PERSONS p where u.person_id=p.person_id and p.person_id=\'"+pid+"\'";
            stmnt2 = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            rset2 = stmnt2.executeQuery(queryOnlyUserOfPerson);
            
            if(!rset2.next()) {
              // no more user accounts exist for this person, so remove person too. 
              rset = stmnt.executeQuery("select person_id from Persons where person_id=\'"+pid+"\'");
              if(rset.next()) {
                rset.deleteRow();
              }
            }
            
            // Show success of removal, returns to usermanage.jsp.
            out.println("The user " + user + " was removed. You will be redirected in 3 seconds.  ");
            String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"usermanage.jsp\"; \',3000);</script>";
            out.println(redirectCode);
          } else {
            // Show that removal went wrong, because that user specified doesn't exist.
            out.println("Something went wrong.");  
          }
          
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      } finally {
        // close the statements, and the connection.
        if(rset != null)
          rset.close();
        if(stmnt != null)
          stmnt.close();
        if(stmnt2 != null)
          stmnt2.close();
        if(rset2 != null)
          rset2.close();
        if(mCon != null)
          mCon.close();
         
      }
    %>
  </div>
</div>
  </body>
</html>
