<!--input-->
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'scientist';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
  <body>
<div>
    <%
    
      Boolean debug = Boolean.TRUE;
      
      String sid = request.getParameter("subToDelete");
      // potentially not safe if someone modifies the options in the list and passes a modified option to this jsp.
    
Integer pid = null;
//Based on tutorials at http://www.tutorialspoint.com/
Cookie cookie = null;
Cookie[] cookies = null;
String comp = "pid";
cookies = request.getCookies();
   if( cookies != null ){
	 for (Integer i = 0; i < cookies.length; i++){
         	cookie = cookies[i];
		
		if(cookie.getName().equals(comp)){

                     pid = Integer.parseInt(cookie.getValue());
}
}
}
  String queryDelSub ="select SENSOR_ID from SUBSCRIPTIONS where SENSOR_ID = "+sid+" and PERSON_ID="+pid;
      
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
            
   
            
            ResultSet rset = stmnt.executeQuery(queryDelSub);
	if(rset.next()) {
            rset.absolute(1);
            rset.deleteRow();

            out.println("The sensor " + sid + " was removed. You will be redirected in 3 seconds.  ");
	String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"subscribe.jsp\"; \',3000);</script>";
              out.println(redirectCode);
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
  </div>
</div>
  </body>
</html>