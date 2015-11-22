<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'admin';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
 <div>
<form action="removeSensor.jsp" id="sensform" method="post">
    <div class="inline" style="border-style:inset;width:75%;">
    <table style="width:100%;border-style:inset";>
    <tr>
  <col>
<col>
<col>
<col>

<col width="150px">
    <th>SENSOR ID</th>
    <th>LOCATION</th>
    <th>TYPE</th>
    <th>DESCRIPTION</th>
    <th><input style="background-color:blue;color:white;display:inline;" type="submit" name="submit" value="Remove Checked Sensor"></th>
    </tr>
    <tr>
       <%
Boolean debug = Boolean.TRUE;
      
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      Integer maxsid = 0;
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
      String querySensors	= "select SENSOR_ID, LOCATION, SENSOR_TYPE, DESCRIPTION from SENSORS";
      // actually log in and perform statements
      try {
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          stmnt = mCon.createStatement();

		String getMaxSID = "select MAX(SENSOR_ID) from SENSORS";
		
          
         	 ResultSet rset2 = stmnt.executeQuery(getMaxSID);
		while(rset2.next()) {
		  maxsid = new Integer(rset2.getInt(1)) + 1;
		}
          
          ResultSet rset = stmnt.executeQuery(querySensors);
          
          while(rset.next()) {
            Integer sID = new Integer(rset.getInt(1));
            String local = rset.getString(2);
            String type = rset.getString(3);
            String desc = rset.getString(4);
            

            
            String open = "<td>";
            String close = "</td>";
	    String tropen = "<tr>";
	    String trclose = "</tr>";	
			
			
		
	    String buttonrm = "<input type='radio' name='sensorToDelete' value='" + sID + "' checked>";
			
            out.println( tropen + open + sID + close + open + local + close + open + type + close + open + desc +  close + open + buttonrm + close + trclose);
            
          }
          
          stmnt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog: Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
      %>
    </tr>
<tr>
    <th>SENSOR ID</th>
    <th>LOCATION</th>
    <th>TYPE</th>
    <th>DESCRIPTION</th>
<th><input style="background-color:blue;color:white;display:inline;" type="submit" name="submit" value="Remove Checked Sensor"></th>
    </tr>
    <tr>
  	 </table>
	</div>
</form>
    
    </div>
 <div class="inline" style="border-style:inset;width:23%;;">
    <form action="createSensor.jsp" id="sensform" method="post">
      <b>Create new sensor:</b><br>
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <input type="number" name="sid" maxlength="38" value="<%= maxsid%>" required placeholder="Sensor ID"><br>
      <input type="text" name="local" maxlength="64" required placeholder="Location"><br>
     	<input type="text" name="stype" maxlength="1" required placeholder="Type"><br>
     	<input type="text" maxlength="128" name="sdesc" required placeholder="Description"></textarea><br>
      <input type="submit" name="submit" value="Create!">
    </form>
    </div>
    </div>
  </body>
</html>
