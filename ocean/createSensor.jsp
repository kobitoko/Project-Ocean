<!--input-->
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'admin';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
<html>
  <head></head>
  <body>
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.TRUE;
      
      // Retrieving all the data from the parameters passed via POST from previous page.
      Integer sid = Integer.parseInt(request.getParameter("sid"));

      String local = request.getParameter("local");
      String type = request.getParameter("stype");
      String desc = request.getParameter("sdesc");
      
      // The queries to use in string format
      String querySensors	= "select SENSOR_ID, LOCATION, SENSOR_TYPE, DESCRIPTION from SENSORS";
      String uniqueSensor ="select SENSOR_ID from SENSORS where SENSOR_ID = "+sid;
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      // Variable to store connection and statements and prepared statements.
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
          // create the connection
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          
          // create the statement
          stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

          // execute query and getting the result set table.
          ResultSet rsetCheck = stmnt.executeQuery(uniqueSensor);
          if(rsetCheck.next()){
            out.println("Sensor " + sid + " is not a unique name. You will be redirected in 3 seconds" );
            String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"sensormanage.jsp\"; \',3000);</script>";
            out.println(redirectCode);
          } else {
            // insert the new sensor in the result set table.
            ResultSet rset = stmnt.executeQuery(querySensors);
            rset.moveToInsertRow();
            rset.updateInt(1,sid);
            rset.updateString(2,local);
            rset.updateString(3,type);
            rset.updateString(4,desc);
            
            rset.insertRow();
            
            // Crearte prepared statement to check if sensor was actually inserted.
            pstmnt = mCon.prepareStatement(uniqueSensor);
            ResultSet rset2 = pstmnt.executeQuery();
          
            if(rset2.next()) {
              out.println("The new sensor " + sid + " was succesfully created. You will be redirected in 3 seconds");
              String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"sensormanage.jsp\"; \',3000);</script>";
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
        // close the statements, the prepared statements, and the connection.
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
