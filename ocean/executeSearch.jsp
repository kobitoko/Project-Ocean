<!--input-->
<%@ page import="java.util.*, java.sql.*, java.text.*"%>
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
	Boolean debug = Boolean.TRUE;
    	/*search conditions. if nothing, it is null*/
        String keywords = request.getParameter("key");
        String sensorType = request.getParameter("stype");
        String location = request.getParameter("local");
	String dateBefore = request.getParameter("dateUntil");
	String dateAfter= request.getParameter("dateSince");
	%><p id="search">Search results where: <%
	
	Integer pid = null;
	//Based on tutorials at http://www.tutorialspoint.com/
	//Grabs pid from cookies.
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

	//Starts the query and checks to make sure data is attached to a subscribed sensor.
	String queryAudio = "SELECT Distinct a.recording_id, a.sensor_id, a.date_created, a.length, a.description FROM sensors sen, audio_recordings a WHERE a.sensor_id in (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";
	String queryImage = "SELECT Distinct i.image_id, i.sensor_id, i.date_created, i.description FROM sensors sen, images i WHERE i.sensor_id in (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";
	String queryScalar = "SELECT Distinct s.id, s.sensor_id, s.date_created, s.value FROM sensors sen, scalar_data s WHERE s.sensor_id in (SELECT sensor_id FROM subscriptions WHERE person_id = "+pid+")";
	//After creating the opening query, the code then adds additional checks via AND statements to the query, based on provided search parameters.




	//Adds a check to make sure that the data's attached sensor is of the required type.
	if (sensorType != null && !sensorType.isEmpty()) {
	   	%>type is <%= sensorType%>, <%

	   sensorType.toLowerCase();
	   queryAudio = queryAudio + " AND sen.sensor_id = a.sensor_id AND sen.sensor_type = '"+ sensorType+"'";
	   queryImage = queryImage + " AND sen.sensor_id = i.sensor_id AND sen.sensor_type = '"+ sensorType+"'";
	   queryScalar = queryScalar + " AND sen.sensor_id = s.sensor_id AND sen.sensor_type = '"+ sensorType+"'";

	   //querySensor = querySensor + " AND sen.sensor_type = '"+sensorType+"'";

	}
	//Adds a check to make sure that the data's attached sensor has the required location.
	if (location != null && !location.isEmpty()) {
		%>location is <%= location%>, <%

	   queryAudio = queryAudio + " AND sen.sensor_id = a.sensor_id AND sen.location = '"+ location+"'";
	   queryImage = queryImage + " AND sen.sensor_id = i.sensor_id AND sen.location = '"+ location+"'";
	   queryScalar = queryScalar + " AND sen.sensor_id = s.sensor_id AND sen.location = '"+ location+"'";

	   //querySensor = querySensor + " And sen.location = '"+ location+"'";

	}
    	//Adds a check to make sure that the data has the exact keywords string match, OR that its sensor attached sensor does.
	if (keywords != null && !keywords.isEmpty()) {
		%>contains the keyword' <%= keywords%>', <%

 	   //queryAudio = queryAudio + " AND a.description LIKE '%"+keywords+"%'";
 	   //queryImage = queryImage + " AND i.description LIKE '%"+keywords+"%'";
	   queryAudio = queryAudio + " AND sen.sensor_id = a.sensor_id AND (a.description = '"+keywords+"' OR sen.description = '"+ keywords+"')";
 	   queryImage = queryImage + " AND sen.sensor_id = i.sensor_id AND (i.description = '"+keywords+"' OR sen.description = '"+ keywords+"')";
 	   queryScalar = queryScalar + " AND sen.sensor_id = s.sensor_id AND sen.description = '"+ keywords+"'";
	   //querySensor = querySensor + " AND sen.description = '"+keywords+"'";



	}
	//Checks to make sure that the data's creation date is after the specification.
	if (dateAfter != null && !dateAfter.isEmpty()) {
		%>contains data recorded after <%= dateAfter%>', <%
		//dateAfter = "AND a.date_created >= TO_DATE("+dateAfter+",'mm/dd/yyyy')";
	   queryAudio = queryAudio + " AND a.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy HH24:MI:SS')";
	   queryImage = queryImage + " AND i.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy HH24:MI:SS')";
	   queryScalar = queryScalar + " AND s.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy HH24:MI:SS')";

	   //querySensor = querySensor + " AND sen.date_created >= TO_DATE('"+dateAfter+"','dd/mm/yyyy')";
	} 
	//Checks to make sure that the data's creation date is before the specification
	if (dateBefore != null && !dateBefore.isEmpty()) {
		%>contains data recorded before <%= dateBefore%>', <%
		//dateBefore = "AND a.date_created <= TO_DATE("+dateBefore+",'mm/dd/yyyy')";
	   queryAudio = queryAudio + " AND a.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy HH24:MI:SS')";
	   queryImage = queryImage + " AND i.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy HH24:MI:SS')";
	   queryScalar = queryScalar + " AND s.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy HH24:MI:SS')";

	   //querySensor = querySensor + " AND sen.date_created <= TO_DATE('"+dateBefore+"','dd/mm/yyyy')";

	} 
	
	%><br><%	

	//This is the version that would allow multiple keywords. According to forum, exact string match is fine.
	//Preserved incase of further specification
	/*
	if (!keywords.isEmpty()) {
	//According to stackexhange, this will also collapse and trim whitespace.
	   List<String> items = Arrays.asList(keywords.split("\\s*,\\s*"));
	}
	*/

	//Dead code. Kept just in case my current assumptions are wrong, and I have to quickly revert.
	//Now, check to see if even if the individual data doesn't match the search, does its sensor?

	queryAudio = queryAudio + " order by a.recording_id";
	queryImage = queryImage + " order by i.image_id";
	queryScalar = queryScalar + " order by s.id";


	
      	String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      	String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      	String mUser = "satyabra";
      	String mPass = "adasfa42";
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
             stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY); 
	     
	     //Each statement must be done one at a time, first is scalar data.
             ResultSet rsetS = stmnt.executeQuery(queryScalar);
	     ResultSetMetaData rsetMetaDataS = rsetS.getMetaData();
	     int Count = rsetMetaDataS.getColumnCount();

//Each statement must be done one at a time, first is scalar data.
%>
<p><u>SCALAR RESULTS</u></p>
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
    
    String csvAppend = "";
    
	String open = "<td>";
           	 String close = "</td>";
	    	 String tropen = "<tr>";
	   	 String trclose = "</tr>";
         
    SimpleDateFormat sdf = null;
    sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    
    while (rsetS.next()) {

	//Displays the data
        Integer did = new Integer(rsetS.getInt(1));
        Integer sid = new Integer(rsetS.getInt(2));
	//Get the datetime and remove milliseconds.
	Timestamp tsOHGOD = rsetS.getTimestamp(3);
        java.util.Date dateTimeOHGOD = null;
        String date = "";
        if(tsOHGOD != null)
            	dateTimeOHGOD = new java.util.Date(tsOHGOD.getTime());
        if(dateTimeOHGOD != null) {
        // taken from http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
            	StringBuffer sb = new StringBuffer();
          	sdf.format(dateTimeOHGOD, sb,new FieldPosition(0));
          	date = sb.toString();
        }
        String val = rsetS.getString(4);
        out.println( tropen + open + did + close + open + sid + close + open + val + close + open + date +  close + trclose);
        
        Timestamp ts = rsetS.getTimestamp(3);
        java.util.Date dateTime = null;
        String dateTimeStr = "";
        if(ts != null)
            dateTime = new java.util.Date(ts.getTime());
        if(dateTime != null) {
            // taken from http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
            StringBuffer sb = new StringBuffer();
            sdf.format(dateTime, sb,new FieldPosition(0));
            dateTimeStr = sb.toString();
            dateTimeStr = dateTimeStr.substring(0, 11) + "&nbsp;" + dateTimeStr.substring(11);
        }
            
        csvAppend = csvAppend.concat( sid.toString() +"%2C"+ dateTimeStr +"%2C"+ val +"%0A");
	}

    out.println("</table>");
    
	// writing into a csv file taken from http://stackoverflow.com/questions/3665115/create-a-file-in-memory-for-user-to-download-not-through-server
    String downloadLink = "<br><a href=\"data:application/csv;charset=utf-8," + csvAppend + "\" download=\"scalar-data_batch("+dateAfter+"_until_"+dateBefore+").csv\" >Click here to <b>download</b></a> this Scalar Data batch. <br>";
    out.println( downloadLink);
         
         
         ResultSet rsetA = stmnt.executeQuery(queryAudio);
	
	     ResultSetMetaData rsetMetaDataA = rsetA.getMetaData();
	     Count = rsetMetaDataA.getColumnCount();
	     String value;
         
//Display Audio data.	
%>

<br>
<p><u>AUDIO RESULTS</u></p>
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
			//Get the datetime and remove milliseconds.
			Timestamp ts = rsetA.getTimestamp(3);
        		java.util.Date dateTime = null;
        		String date = "";
        		if(ts != null)
            			dateTime = new java.util.Date(ts.getTime());
        		if(dateTime != null) {
           		 // taken from http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
            			StringBuffer sb = new StringBuffer();
          			sdf.format(dateTime, sb,new FieldPosition(0));
          			date = sb.toString();
        }

			Integer len = new Integer(rsetA.getInt(4));
			String val = rsetA.getString(5);
			
			String downloadButton = "<center><form action=\"download.jsp\" target=\"_blank\" method=\"post\">  <input type=\"hidden\" id=\"downloadid\" name=\"downloadid\" value=\""+did.toString()+"\">  <input type=\"hidden\" id=\"downloadtype\" name=\"downloadtype\" value=\"audio\">  <input type=\"submit\" name=\"submit\" value=\"Download\">  </form></center>";
			
			out.println( tropen + open + did + close + open + sid + close + open + len + close + open + val + close + open + downloadButton + close + open + date +  close + trclose);
	
	}
             ResultSet rsetI = stmnt.executeQuery(queryImage);

	     ResultSetMetaData rsetMetaDataI = rsetI.getMetaData();
	     Count = rsetMetaDataI.getColumnCount();

//Display image data
%>

</table>
<br>
<p><u>IMAGES RESULTS</u></p>
<table style="border-style:inset";>


	<tr>
<col width="150px">
<col width="150px">
<col width="150px">
<col width="150px">


    	<th>DATA ID</th>
    	<th>SENSOR ID</th>
   	 <th>DESCRIPTION</th>
   	 <th>THUMBNAIL</th>
	 <th>DOWNLOAD</th>
	<th>DATE CREATED</th>

	</tr>

<%
	     while (rsetI.next()) {
		
			Integer did = new Integer(rsetI.getInt(1));
			Integer sid = new Integer(rsetI.getInt(2));
			//Get the datetime and remove milliseconds.
			Timestamp ts = rsetI.getTimestamp(3);
        		java.util.Date dateTime = null;
        		String date = "";
        		if(ts != null)
            			dateTime = new java.util.Date(ts.getTime());
        		if(dateTime != null) {
           		 // taken from http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
            			StringBuffer sb = new StringBuffer();
          			sdf.format(dateTime, sb,new FieldPosition(0));
          			date = sb.toString();
        }
			String val = rsetI.getString(4);
			
			Blob blob = null;
			String thumbnailStr = "";
			PreparedStatement ps = mCon.prepareStatement("select thumbnail from images where image_id=?");
			ps.setInt(1, did);
    		ResultSet rs = ps.executeQuery();
    		
			if(rs != null) {
			    rs.next();
			    blob = rs.getBlob(1);
    	    	rs.close();
    	    }
			if(ps != null)
    			ps.close();
			
			if(blob != null) {
	    		// apparently the first byte is at position 1 according to the docs.
    			byte[] imgByte = blob.getBytes((long) 1, (int) blob.length());
			    thumbnailStr = new String(imgByte, "UTF-8");
			}
			
            String thumbnailHTML = "<img src=\""+thumbnailStr+"\" ";
			
			// This is bad, you already "downloading" the images and storing it on the clients browser. Thus submit form the id of the file, and then you can just download it in download.jsp		
			String downloadButton = "<center><form action=\"download.jsp\" target=\"_blank\" method=\"post\">  <input type=\"hidden\" id=\"downloadid\" name=\"downloadid\" value=\""+did.toString()+"\">  <input type=\"hidden\" id=\"downloadtype\" name=\"downloadtype\" value=\"image\">  <input type=\"submit\" name=\"submit\" value=\"Download\">  </form></center>";
			
		out.println( tropen + open + did + close + open + sid + close  + open + val + close + open + thumbnailHTML + close + open + downloadButton + close + open + date +  close + trclose);

	}	 
            
            /*Display all hits. */
        } catch(SQLException ex) {
            if (debug)
              out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage() +"<BR><BR>"+ queryImage + "<BR><BR>" + queryAudio + "<BR><BR>" +queryScalar );
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
