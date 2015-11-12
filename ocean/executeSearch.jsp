<!--input-->
<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
  <body>
    <%
        Boolean debug = Boolean.TRUE;
	//CURRENTLY BROKEN. RELIES ON A VIEW THAT DOESN"T EXIST, THAT I CAN'T MAKE UNTIL I HAVE PERSON.ID
    	/*search conditions. default is blank.*/
        String keywords = request.getParameter("key");
        String sensorType = request.getParameter("stype");
        String location = request.getParameter("local");
	String dateBefore = request.getParameter("dateUntil");
	String dateAfter= request.getParameter("dateSince");
	/*When adding a thing, make sure to add rest of query before hand.*/ 
	String queryAudio = "SELECT Distinct a.recording_id, a.sensor_id, a.date_created, a.length, a.description FROM sensors sen, audio_recordings a, subscribed_sensors WHERE a.sensor_id in (select * from subscribed_sensors)";


	if (sensorType != null && !sensorType.isEmpty()) {
	   //sensorType = "AND sen.sensor_id = a.sensor_id AND sen.sensor_type = "+ sensorType;
	   queryAudio = queryAudio + "AND sen.sensor_id = a.sensor_id AND sen.sensor_type = "+ sensorType;

	}
	if (location != null && !location.isEmpty()) {
	   //location = "AND sen.sensor_id = a.sensor_id AND sen.location= "+ location;
	   queryAudio = queryAudio + "AND sen.sensor_id = a.sensor_id AND sen.location= "+ location;

	}    
	if (keywords != null && !keywords.isEmpty()) {
	    //keywords = "AND a.description LIKE '%"+keywords+"%'";
 	   queryAudio = queryAudio + "AND a.description LIKE '%"+keywords+"%'";
	}
	if (dateBefore != null && !dateBefore.isEmpty()) {
		//dateBefore = "AND a.date_created <= TO_DATE("+dateBefore+",'mm/dd/yyyy')";
	   queryAudio = queryAudio + "AND a.date_created <= TO_DATE("+dateBefore+",'mm/dd/yyyy')";

	} 
	if (dateAfter != null && !dateAfter.isEmpty()) {
		//dateAfter = "AND a.date_created >= TO_DATE("+dateAfter+",'mm/dd/yyyy')";
	   queryAudio = queryAudio + "AND a.date_created >= TO_DATE("+dateAfter+",'mm/dd/yyyy')";
	} 
		
	//Currently have redudent search conditions if multiple search conditions.
	//String queryAudio = "SELECT Distinct a.recording_id, a.sensor_id, a.date_created, a.length, a.description FROM sensors sen, audio_recordings a, subscribed_sensors WHERE a.sensor_id in (select * from subscribed_sensors)" + sensorType + location+ dateBefore+dateAfter+keywords+ ";"; 

	//This is the version that would allow multiple keywords. According to forum, exact string match is fine.
	/*
	if (!keywords.isEmpty()) {
	//According to stackexhange, this will also collapse and trim whitespace.
	   List<String> items = Arrays.asList(keywords.split("\\s*,\\s*"));
	}
	*/
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      //String mUser = "koukoula";
      //String mPass = "diamondT1ara";
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
        try {
	  
            mCon = DriverManager.getConnection(mUrl, mUser, mPass);

            stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
             	
             ResultSet rset = stmnt.executeQuery(queryAudio);
	
	     
		
	     ResultSetMetaData rsetMetaData = rset.getMetaData();
	     int cCount = rsetMetaData.getColumnCount();
	     String value;
	     Object o;	
	while (rset.next()) {
		for (int i = 1; i <= cCount; i++){
			o = rset.getObject(i);
			if (o!=null) value = o.toString();
			else value = "null";
			out.print(value);
		}
	}	 
	
	    /*while going through the result set, must search the descriptions for keywords.*/
            /*Display all hits. */
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
