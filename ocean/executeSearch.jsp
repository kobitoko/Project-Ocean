<!--input-->
<%@ page import="java.util.*, java.sql.*"%>
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

    <%
//todos based on: 
//https://eclass.srv.ualberta.ca/mod/page/view.php?id=1627717
//DONE on my end. Need to edit html side:  dd/mm/yyyy. 
//DONE: keyword should be exact match.
//TODO: Ask TA if the user needs to be able to search by hour,min,second. If so, implement that.
//TODO: Apparently Sensor type must have a time period.
//TODO: Select blob columns.
//DONE: "If the keyword matches the sensor description, show all data from this sensor. 
//If not (in case of audio files and images), try if it matches the image or audio description 
//and show those records which match."
//DONE in a sense. Need to handle it website side as well: Error catching. A common offender will be if they input date off format.
//TODO: Testing Website side.
        Boolean debug = Boolean.TRUE;
    	/*search conditions. if nothing, it is null*/
        String keywords = request.getParameter("key");
        String sensorType = request.getParameter("stype");
        String location = request.getParameter("local");
	String dateBefore = request.getParameter("dateUntil");
	String dateAfter= request.getParameter("dateSince");
	%><p id="search">Search results where: <%
	
	//String pId = ???
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

	//Version 1, designed to be slightly easier by creating a view first, and then checking if id in view.

/*
	String createView = "CREATE OR REPLACE VIEW SUBSCRIBED_SENSORS AS SELECT DISTINCT sub.sensor_id  FROM subscriptions sub WHERE sub.person_id = " + pid;

	String queryAudio = "SELECT Distinct a.recording_id, a.sensor_id, a.date_created, a.length, a.description FROM sensors sen, audio_recordings a, subscribed_sensors WHERE a.sensor_id in (select * from subscribed_sensors)";
	String queryImage = "SELECT Distinct i.image_id, i.sensor_id, i.date_created, i.description FROM sensors sen, images i, subscribed_sensors WHERE i.sensor_id in (select * from subscribed_sensors)";
	String queryScalar = "SELECT Distinct s.id, s.sensor_id, s.date_created, s.value FROM sensors sen, scalar_data s, subscribed_sensors WHERE s.sensor_id in (select * from subscribed_sensors)";
*/	
	//Version 2. Goes through subscriptions itself.
	//Had to insert brackets before the WHERE, and around query sensor.
	String queryAudio = "SELECT Distinct a.recording_id, a.sensor_id, a.date_created, a.length, a.description FROM sensors sen, audio_recordings a WHERE (a.sensor_id in (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";
	String queryImage = "SELECT Distinct i.image_id, i.sensor_id, i.date_created, i.description FROM sensors sen, images i WHERE (i.sensor_id in (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";
	String queryScalar = "SELECT Distinct s.id, s.sensor_id, s.date_created, s.value FROM sensors sen, scalar_data s WHERE (s.sensor_id in (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";

	//Check if the associated sensor is found as well. 
	String querySensor = "(SELECT Distinct sen.sensor_id FROM sensors sen WHERE sen.sensor_ID IN (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";

 

//Currently does not select any blop fields. Easily added when we have test data that has it. 
	if (sensorType != null && !sensorType.isEmpty()) {
	   	%>type is <%= sensorType%>, <%
	   //sensorType = "AND sen.sensor_id = a.sensor_id AND sen.sensor_type = "+ sensorType;
	   sensorType.toLowerCase();
	   queryAudio = queryAudio + " AND sen.sensor_id = a.sensor_id AND sen.sensor_type = '"+ sensorType+"'";
	   queryImage = queryImage + " AND sen.sensor_id = i.sensor_id AND sen.sensor_type = '"+ sensorType+"'";
	   queryScalar = queryScalar + " AND sen.sensor_id = s.sensor_id AND sen.sensor_type = '"+ sensorType+"'";

	   querySensor = querySensor + " AND sen.sensor_type = '"+sensorType+"'";

	}
	if (location != null && !location.isEmpty()) {
		%>location is <%= location%>, <%
	   //location = "AND sen.sensor_id = a.sensor_id AND sen.location= "+ location;
	   queryAudio = queryAudio + " AND sen.sensor_id = a.sensor_id AND sen.location = '"+ location+"'";
	   queryImage = queryImage + " AND sen.sensor_id = i.sensor_id AND sen.location = '"+ location+"'";
	   queryScalar = queryScalar + " AND sen.sensor_id = s.sensor_id AND sen.location = '"+ location+"'";

	   querySensor = querySensor + " And sen.location = '"+ location+"'";

	}
    
	if (keywords != null && !keywords.isEmpty()) {
		%>contains the keyword' <%= keywords%>', <%
	    //keywords = "AND a.description LIKE '%"+keywords+"%'";
 	   //queryAudio = queryAudio + " AND a.description LIKE '%"+keywords+"%'";
 	   //queryImage = queryImage + " AND i.description LIKE '%"+keywords+"%'";
	   queryAudio = queryAudio + " AND a.description = '"+keywords+"'";
 	   queryImage = queryImage + " AND i.description = '"+keywords+"'";

	   querySensor = querySensor + " AND sen.description = '"+keywords+"'";



	}
	if (dateBefore != null && !dateBefore.isEmpty()) {
		%>contains data recorded before <%= dateBefore%>', <%
		//dateBefore = "AND a.date_created <= TO_DATE("+dateBefore+",'mm/dd/yyyy')";
	   queryAudio = queryAudio + " AND a.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy')";
	   queryImage = queryImage + " AND i.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy')";
	   queryScalar = queryScalar + " AND s.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy')";

	   //querySensor = querySensor + " AND sen.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy')";


	} 
	if (dateAfter != null && !dateAfter.isEmpty()) {
		%>contains data recorded after <%= dateAfter%>', <%
		//dateAfter = "AND a.date_created >= TO_DATE("+dateAfter+",'mm/dd/yyyy')";
	   queryAudio = queryAudio + " AND a.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy')";
	   queryImage = queryImage + " AND i.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy')";
	   queryScalar = queryScalar + " AND s.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy')";

	   //querySensor = querySensor + " AND sen.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy')";


	} 
	%><br><%	
	//Currently have redudent search conditions if multiple search conditions.
	//String queryAudio = "SELECT Distinct a.recording_id, a.sensor_id, a.date_created, a.length, a.description FROM sensors sen, audio_recordings a, subscribed_sensors WHERE a.sensor_id in (select * from subscribed_sensors)" + sensorType + location+ dateBefore+dateAfter+keywords+ ";"; 

	//This is the version that would allow multiple keywords. According to forum, exact string match is fine.
	/*
	if (!keywords.isEmpty()) {
	//According to stackexhange, this will also collapse and trim whitespace.
	   List<String> items = Arrays.asList(keywords.split("\\s*,\\s*"));
	}
	*/


	//Now, check to see if even if the individual data doesn't match the search, does its sensor?
	queryAudio = queryAudio + ") OR (a.sensor_id IN " +querySensor+"))";
	queryImage = queryImage + ") OR (i.sensor_id IN " +querySensor+"))";
	queryScalar = queryScalar + ") OR (s.sensor_id IN " +querySensor+"))";

	
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      //String mUser = "koukoula";
      //String mPass = "diamondT1ara";
      Connection mCon = null;
      Statement stmnt = null;
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

	     //stmntView = mCon.createStatement();
             //stmntView.executeQuery(createView);
	     //stmntView.close();

             stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY); 
	 ResultSet rsetS = stmnt.executeQuery(queryScalar);

	     ResultSetMetaData rsetMetaDataS = rsetS.getMetaData();
	     int Count = rsetMetaDataS.getColumnCount();

%>
<p>SCALAR RESULTS</p>
<table style="border-style:inset";>


	<tr>
<col width="150px">
<col width="150px">
<col width="150px">
<col width="150px">


    	<th>DATA ID</th>
    	<th>SENSOR ID</th>
   	 <th>VALUE</th>
	<th>DATE CREATED</th>

	</tr>
<%
	String open = "<td>";
           	 String close = "</td>";
	    	 String tropen = "<tr>";
	   	 String trclose = "</tr>";
	     while (rsetS.next()) {
		
		
			Integer did = new Integer(rsetS.getInt(1));
			Integer sid = new Integer(rsetS.getInt(2));
			java.sql.Date date = rsetS.getDate(3);
			String val = rsetS.getString(4);
			out.println( tropen + open + did + close + open + sid + close + open + val + close + open + date +  close + trclose);
		
	}	
	
             ResultSet rsetA = stmnt.executeQuery(queryAudio);
	
	    
	
	     ResultSetMetaData rsetMetaDataA = rsetA.getMetaData();
	     Count = rsetMetaDataA.getColumnCount();
	     String value;
	    

%>
</table>
<p>AUDIO RESULTS</p>
<table style="border-style:inset";>


	<tr>
<col width="150px">
<col width="150px">
<col width="150px">
<col width="150px">


    	<th>DATA ID</th>
    	<th>SENSOR ID</th>
   	 <th>LENGTH</th>
	 <th>DESCRIPTION</th>
	 <th>DOWNLOAD</th>
	<th>DATE CREATED</th>

	</tr>

<%
	     while (rsetA.next()) {
		
			Integer did = new Integer(rsetA.getInt(1));
			Integer sid = new Integer(rsetA.getInt(2));
			java.sql.Date date = rsetA.getDate(3);
			Integer len = new Integer(rsetA.getInt(4));
			String val = rsetA.getString(5);
			out.println( tropen + open + did + close + open + sid + close + open + len + close + open + val + close + open + close + open + date +  close + trclose);
	
	}
             ResultSet rsetI = stmnt.executeQuery(queryImage);

	     ResultSetMetaData rsetMetaDataI = rsetI.getMetaData();
	     Count = rsetMetaDataI.getColumnCount();

%>
</table>
<p>IMAGES RESULTS</p>
<table style="border-style:inset";>


	<tr>
<col width="150px">
<col width="150px">
<col width="150px">
<col width="150px">


    	<th>DATA ID</th>
    	<th>SENSOR ID</th>
   	 <th>DESCRIPTION</th>
	 <th>DOWNLOAD</th>
	<th>DATE CREATED</th>

	</tr>

<%
	     while (rsetI.next()) {
		
			Integer did = new Integer(rsetI.getInt(1));
			Integer sid = new Integer(rsetI.getInt(2));
			java.sql.Date date = rsetI.getDate(3);
			String val = rsetI.getString(4);
		out.println( tropen + open + did + close + open + sid + close  + open + val + close + open + close + open + date +  close + trclose);
		
	}	 
            

 
	 
            /*Display all hits. */
        } catch(SQLException ex) {
            if (debug)
              out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage() +"\n"+ queryImage + "\n" + queryAudio + "\n" +queryScalar );
            System.err.println("SQLException: " + ex.getMessage());
	//Need to close connections if they exist here. But I don't know how to check if there is currently a connection.
        } 
	finally {
		stmnt.close();
        	mCon.close();
	}
          

	     
   %>
 </table>
</div>
</body>
</html>
