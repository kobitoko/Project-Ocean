<!--input-->
<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
  <body>
    <%
      
      Boolean debug = Boolean.TRUE;
      
      //special html characters from https://www.utexas.edu/learn/html/spchar.html
      //escape characters in html workaround from http://javarevisited.blogspot.sg/2012/09/how-to-replace-escape-xml-special-characters-java-string.html
      String beginHTML = "<form action=\"removeThatAccount.jsp\" method=\"post\"> <b>Select the user you want to remove:</b><br>";
      out.println(beginHTML);

      
      String queryUsers = "select USER_NAME from USERS";
      
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
          stmnt = mCon.createStatement();
          
          ResultSet rset = stmnt.executeQuery(queryUsers);
          
          String beginSel = "<select name=\"userToDelete\"";
          out.println(beginSel);
          
          // TODO: handle when no users exists. Disable buttons etc.
          while(rset.next()) {
            String usr = rset.getString(1);
            // taken from www.w3schools.com/tags/tag_select.asp
            String beginOption = "<option value=\"";
            String optionValue = "\">";
            out.println( beginOption + usr + optionValue + usr + "</option>");
          }
            
          String endSel = "</select><br><input type=\"submit\" name=\"submit\" value=\"remove\">";
          out.println(endSel);
          
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
