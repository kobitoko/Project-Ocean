<%@ page import="java.util.*, java.sql.*"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Ocean Observation System</title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script src="analyzeSensor.js"></script>
<script>permission = 'scientist';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
<div>
<b> My Subscriptions </b>
<form action="analyzeSensor.jsp" id="unsubSensor" method="post">
<div>

</div>
<table style="width:100%;border-style:inset";>
    <tr>
<col>
<col>
<col>
<col>
<col width="150px">
    <th>Sensor ID</th>
    <th>Location</th>
    <th>Sensor Type</th>
    <th>Description</th>
    <th><button onClick="olapSensor()"style="background-color:green;color:white;display:inline;">Analyze Sensor</button></th>
    </tr>
    <tr>
    <%

//Grabs the pid from cookies
Integer pid = null;
//Based on tutorials at http://www.tutorialspoint.com/
Cookie cookie = null;
Cookie[] cookies = null;
String comppid = "pid";
cookies = request.getCookies();
   if( cookies != null ){
	 for (Integer i = 0; i < cookies.length; i++){
         	cookie = cookies[i];
		
		if(cookie.getName().equals(comppid)){pid = Integer.parseInt(cookie.getValue());}
}
}

	
	Boolean debug = Boolean.TRUE;

//queries
      String queryMySensors	= "select S.SENSOR_ID, S.LOCATION, S.SENSOR_TYPE, S.DESCRIPTION from SENSORS S, SUBSCRIPTIONS T where S.SENSOR_ID=T.SENSOR_ID and T.PERSON_ID="+pid+"order by S.SENSOR_ID";
      String querySensors	= "select distinct S.SENSOR_ID, S.LOCATION, S.SENSOR_TYPE, S.DESCRIPTION from SENSORS S, SUBSCRIPTIONS T where S.SENSOR_ID not in (select S.SENSOR_ID from SENSORS S, SUBSCRIPTIONS T where S.SENSOR_ID=T.SENSOR_ID and T.PERSON_ID="+pid+")order by S.SENSOR_ID";
      
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
          
          ResultSet rset = stmnt.executeQuery(queryMySensors);
          
	//iterate through the results
          while(rset.next()) {
            Integer sID = new Integer(rset.getInt(1));
            String local = rset.getString(2);
            String type = rset.getString(3);
            String desc = rset.getString(4);
            

            
            String open = "<td>";
            String close = "</td>";
	    String tropen = "<tr>";
	    String trclose = "</tr>";	
			
			
		//output as table
	    String buttonrm = "<input type='radio' name='subToAnal' value='" + sID + "' checked>";
			
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

  	 </table>
     
     </form>
</div>

</div>
<br><br>

</div>
</body>
</html>
