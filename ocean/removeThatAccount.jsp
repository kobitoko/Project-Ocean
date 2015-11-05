<!--input-->
<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
  <body>
    <%
    
      Boolean debug = Boolean.TRUE;
      
      String user = request.getParameter("userToDelete");
      // potentially not safe if someone modifies the options in the list and passes a modified option to this jsp.
      String queryDelUsr = "select USER_NAME from USERS where USER_NAME=\'" + user +"\'";
      String queryDelSalt = "select USER_NAME from SALTS where USER_NAME=\'" + user +"\'";
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
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
            mCon = DriverManager.getConnection(mUrl, mUser, mPass);
            stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            
            // Remove first those who depend on the foreign primary key USER_NAME.
            ResultSet rset = stmnt.executeQuery(queryDelSalt);
            if(rset.next()) {
            rset.absolute(1);
            rset.deleteRow();
            
            rset = stmnt.executeQuery(queryDelUsr);
            rset.absolute(1);
            rset.deleteRow();

            out.println("The user " + user + " was removed.");
          } else {
            out.println("Something went wrong.");  
          }
          
          stmnt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
    %>
  
  </body>
</html>
