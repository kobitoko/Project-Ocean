<%@ page import="java.util.*, java.sql.*"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Ocean Observation System</title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'scientist';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<div>
<b> My Subscriptions </b>
<form action="unsubSensor.jsp" id="unsubSensor" method="post">
<div>
<input  type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Unsubscribe to checked Sensors">
</div>
<table style="width:100%;border-style:inset";>
    <tr>
    <th>Sensor ID</th>
    <th>Location</th>
    <th>Sensor Type</th>
    <th>Description</th>
    <th>Unsubscirbe</th>
    </tr>
    <tr>
    <%
	Boolean debug = Boolean.TRUE;
      String querySubs 		= "select SENSOR_ID, PERSON_ID from SUBSCRIPTIONS";
	  String querySensors	= "select SENSOR_ID, LOCATION, SENSOR_TYPE, DESCRIPTION from SENSORS";
      
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
%>
      
    </tr>
  	 </table>
     <input type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Unsubscribe to checked Sensors">
     </form>
</div>
<div style="border-style:inset;">
<p style="display:inline"><b>Directly add by Sensor ID</b></p><form action="subSensor.jsp" id="subSensor" method="post">
<input type="text" name="sid" maxlength="32" required placeholder="Sensor ID"><input type="submit" style="background-color:blue;color:white;" name="submit" value="Subscribe to Sensor">
     </form>
</form>

</div>
<br><br>
<div>
<b>Other Sensors</b>
<form action="subSensor.jsp" id="subSensor" method="post">
<input type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Subscribe to new Sensors">
<table style="width:100%;border-style:inset";>
    <tr>
    <th>Sensor ID</th>
    <th>Location</th>
    <th>Sensor Type</th>
    <th>Description</th>
    <th>Subscirbe</th>
    </tr>
    <tr>
 <%
	
      
      
      // actually log in and perform statements
      try {
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          stmnt = mCon.createStatement();
          
          ResultSet rset = stmnt.executeQuery(querySubs);
		  ResultSet rsetSen = stmnt.executeQuery(querySensors);
		  
	// rset.last(); 
         int total = 12;
	 //rset.first();	  
         String[] subs = new String[total];
		  int count = 0;
		  while(rset.next()) {
			  subs[count] = rset.getString(1);
		  }
          
          while(rsetSen.next()) {
            String sid = rset.getString(1);
            String local = rset.getString(2);
            String stype = rset.getString(3);
            String desc= rset.getString(4);
            if(Arrays.asList(subs).contains(sid)){
			}else{
				String open = "<td>";
				String close = "</td>";
				String tropen = "<tr>";
				String trclose = "</tr>";	
				String subcheck = "<input type='radio' name='subToAdd' value='" + sid + "'>";
				out.println( tropen + open + sid + close + open + local + close + open + stype + close + open + desc +  close + open + subcheck + close + trclose);
			}
            
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
  	 </table>
    <input type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Subscribe to new Sensors">
     </form>
</div>
</div>
</body>
</html>
