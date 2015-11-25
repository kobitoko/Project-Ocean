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
      String sid = request.getParameter("sensorToDelete");
      
      // The queries to use in string format
      // potentially not safe if someone modifies the options in the list and passes a modified option to this jsp.
      String queryDelSensor ="select SENSOR_ID from SENSORS where SENSOR_ID = "+sid;
      String queryDelSubs ="select SENSOR_ID from SUBSCRIPTIONS where SENSOR_ID="+sid;
      String queryDelScalar ="select SENSOR_ID from SCALAR_DATA where SENSOR_ID="+sid;
      String queryDelAudio ="select SENSOR_ID from AUDIO_RECORDINGS where SENSOR_ID="+sid;
      String queryDelImage ="select SENSOR_ID from IMAGES where SENSOR_ID="+sid;

      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "TRY HARDER";
      String mPass = "TRY HARDER";
      
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
        
        //execute query to remove the subscribers.
        ResultSet rsetpre = stmnt.executeQuery(queryDelSubs);
        while(rsetpre.next()) {
          rsetpre.absolute(1);
          rsetpre.deleteRow();
        } 
        
        //execute query to remove the scalar data.
        rsetpre = stmnt.executeQuery(queryDelScalar);
        while(rsetpre.next()) {
          rsetpre.absolute(1);
          rsetpre.deleteRow();
        } 
        
        //execute query to remove the audio data.
        rsetpre = stmnt.executeQuery(queryDelAudio);
        while(rsetpre.next()) {
          rsetpre.absolute(1);
          rsetpre.deleteRow();
        }
        
        //execute query to remove the image data.
        rsetpre = stmnt.executeQuery(queryDelImage);
        while(rsetpre.next()) {
          rsetpre.absolute(1);
          rsetpre.deleteRow();
        } 
        
        //execute query to finally remove the sensor.
        ResultSet rset = stmnt.executeQuery(queryDelSensor);
        if(rset.next()) {
          rset.absolute(1);
          rset.deleteRow();
          
          // Show success of removal, redirected to sensormanage.jsp.
          out.println("The sensor " + sid + " was removed. You will be redirected in 3 seconds.  ");
          
          String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"sensormanage.jsp\"; \',3000);</script>";
          out.println(redirectCode);
        } else {
          out.println("Something went wrong.");  
        }
        
        // close the statements and the connection.
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
