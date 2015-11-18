<!--input-->
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'scientist';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<html>
  <head></head>
  <body>
    <%
      
      Boolean debug = Boolean.TRUE;
      
     
      Integer sid = Integer.parseInt(request.getParameter("subToAdd"));
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
      
      String querySubs	= "select SENSOR_ID, PERSON_ID from SUBSCRIPTIONS";
      String uniqueSubs ="select SENSOR_ID from SUBSCRIPTIONS where SENSOR_ID="+sid+" and PERSON_ID="+pid;
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
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
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
          

	  
          ResultSet rsetCheck = stmnt.executeQuery(uniqueSubs);
	if(rsetCheck.next()){
		out.println("You are already subscribed to " + sid + ". You will be redirected in 3 seconds" );
  String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"subscribe.jsp\"; \',3000);</script>";
              out.println(redirectCode);
} else {
	ResultSet rset = stmnt.executeQuery(querySubs);
          rset.moveToInsertRow();
          rset.updateInt(1,sid);
          rset.updateInt(2,pid);
          
          rset.insertRow();
          
          ResultSet rset2 = stmnt.executeQuery(uniqueSubs);

          
          if(rset2.next()) {
            out.println("The new subscription to sensor " + sid + " was succesfully created. You will be redirected in 3 seconds");
            String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"subscribe.jsp\"; \',3000);</script>";
              out.println(redirectCode);
          } else {
            out.println("Something went wrong...<br>Failed to create the new sensor " + sid + "." );
          }
}


          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      } finally {
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