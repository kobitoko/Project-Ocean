<!--input-->
<%@ page import="java.util.*, java.sql.*, java.io.*, java.text.* "%>
<head>
<meta charset="utf-8">
<title>Ocean Observation System</title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script src="search.js"></script>
<script>permission = 'curator';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
 <div id='content'>
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.TRUE;
      
      // Retrieving all the jpeg related parameters passed via POST from previous page.
      String imageBase64Input = request.getParameter("jpgfileput");
      String imageThumbBase64Input = request.getParameter("jpgthumbnailfileput");
      Integer imageSensorId = 0;
      if(!(request.getParameter("jpgsensorid")).isEmpty())
        imageSensorId = Integer.parseInt((request.getParameter("jpgsensorid")));
      String imageTimeCreated = request.getParameter("jpgtimecreated");
      String imageDateCreated = request.getParameter("jpgdatecreated");
      String imageDescription = request.getParameter("jpgdescription");
      
      // Retrieving all the audio related parameters passed via POST from previous page.
      String audioBase64Input = request.getParameter("audiofileput");
      Integer audioSensorId = 0;
      if(!(request.getParameter("wavsensorid")).isEmpty())
        audioSensorId = Integer.parseInt((request.getParameter("wavsensorid")));
      String audioTimeCreated = request.getParameter("wavtimecreated");
      String audioDateCreated = request.getParameter("wavdatecreated");
      Integer audioLength = 0;
      if(!(request.getParameter("wavlength")).isEmpty())
        audioLength = Integer.parseInt((request.getParameter("wavlength")));
      String audioDescription = request.getParameter("wavdescription");

      // Retrieving dataUrl string of the CSV related parameter passed via POST from previous page.
      String csvFileContent = request.getParameter("csvfileput");
      
      // variables storing the bytes of the input file for images.
      byte[] imageByteArr = null;
      byte[] imageThumbByteArr = null;
      // stores the length/filesize-in-bytes of the image and thumbnail bytearray.
      int imageByteArrSize = 0;
      int imageThumbByteArrSize = 0;
      // the input stream that passes this byte data into the prepared statement later.
      InputStream jpgStream = null;
      InputStream jpgThumbStream = null;
      
      // variables storing the bytes of the input file for audio.
      byte[] audioByteArr = null;
      // stores the length/filesize-in-bytes of the audio and thumbnail bytearray.
      int audioByteArrSize = 0;
      // the input stream that passes this byte data into the prepared statement later.
      InputStream wavStream = null;

      // Converts the image's base64 dataUrl into a byte array in UTF-8 character encoding format and streamed into the input stream.
      // taken from http://stackoverflow.com/questions/782178/how-do-i-convert-a-string-to-an-inputstream-in-java 
      if(!imageBase64Input.isEmpty()) {
        imageByteArr = imageBase64Input.getBytes("UTF-8");
        imageThumbByteArr = imageThumbBase64Input.getBytes("UTF-8");
        imageByteArrSize = imageByteArr.length;
        imageThumbByteArrSize = imageThumbByteArr.length;
        jpgStream = new ByteArrayInputStream(imageByteArr);
        jpgThumbStream = new ByteArrayInputStream(imageThumbByteArr);
      }
      
      // Converts the audio's base64 dataUrl into a byte array in UTF-8 character encoding format and streamed into the input stream.
      if(!audioBase64Input.isEmpty()) {
        audioByteArr = audioBase64Input.getBytes("UTF-8");
        audioByteArrSize = audioByteArr.length;
        wavStream = new ByteArrayInputStream(audioByteArr);
      }
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
      String mUser = "TRY HARDER";
      String mPass = "TRY HARDER";
      
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
      
      // Variable to store connection and prepared statements and result set table.
      Connection mCon = null;
      Statement maxIdValues = null;
      ResultSet maxIdVals = null;
      PreparedStatement jpgData = null;
      PreparedStatement wavData = null;
      PreparedStatement csvData = null;
      
      // actually log in and perform statements
      try{
        // creates a connection
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        // disables autocommit.
        mCon.setAutoCommit(Boolean.FALSE);
        
        // This query and result table retrieves the highest value of the unique key ID's of the table images, audio_recordings, and scalar_data (seperately).
        // for getting 0 number when max value of id in table is nothing (table empty) http://stackoverflow.com/questions/15475059/how-to-treat-max-of-empty-table-as-0-instead-of-null
        String queryMaxIdValues = "select coalesce(MAX(i.image_id), 0), coalesce(MAX(a.recording_id), 0), coalesce(MAX(d.id), 0) from images i, audio_recordings a, scalar_data d";
        maxIdValues = mCon.createStatement();
        maxIdVals = maxIdValues.executeQuery(queryMaxIdValues);
        maxIdVals.next();
        // Store the highest unique key id value.
        Integer maxImageId = Integer.valueOf(maxIdVals.getInt(1));
        Integer maxAudioId = Integer.valueOf(maxIdVals.getInt(2));
        Integer maxScalarId = Integer.valueOf(maxIdVals.getInt(3));
        
        // If no image dataUrl was received, skip image uploading.
        if(!imageBase64Input.isEmpty()) {
          // Create the insert prepared statement to insert and upload the image and relating data to the database.
          // to_date query format masks taken from http://www.dba-oracle.com/f_to_date.htm
          jpgData = mCon.prepareStatement("insert into IMAGES (image_id, sensor_id, date_created, description, thumbnail, recoreded_data) values (?,?,TO_DATE(?,'DD/MM/YYYY HH24:MI:SS'),?,?,?)");
          jpgData.setInt(1, maxImageId+1);
          jpgData.setInt(2, imageSensorId);
          jpgData.setString(3, imageDateCreated + " " + imageTimeCreated);
          jpgData.setString(4, imageDescription);
          // set blob taken from http://www.ibmpressbooks.com/articles/article.asp?p=1146304&seqNum=3
          jpgData.setBlob(5, jpgThumbStream, imageThumbByteArrSize);
          jpgData.setBlob(6, jpgStream, imageByteArrSize);
          jpgData.executeUpdate();
        }
        
        // If no audio dataUrl was received, skip audio uploading.
        if(!audioBase64Input.isEmpty()) {
          // Create the insert prepared statement to insert and upload the audio and relating data to the database.
          wavData = mCon.prepareStatement("insert into audio_recordings (recording_id, sensor_id, date_created, length, description, recorded_data) values (?,?,TO_DATE(?,'DD/MM/YYYY HH24:MI:SS'),?,?,?)");
          wavData.setInt(1, maxAudioId+1);
          wavData.setInt(2, audioSensorId);
          wavData.setString(3, audioDateCreated + " " + audioTimeCreated);
          wavData.setInt(4, audioLength);
          wavData.setString(5, audioDescription);              
          wavData.setBlob(6, wavStream, audioByteArrSize);
          wavData.executeUpdate();
        }  

        // If no CSV batch scalar data dataUrl was received, skip scalar data uploading.
        if(!csvFileContent.isEmpty()) {
          // csv https://en.wikipedia.org/wiki/Comma-separated_values
          // To split strings using patterns from https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html#sum
          String regexDelimiters = "[,(\n$)]";
          String[] datas = csvFileContent.split(regexDelimiters);
          
          // CSV contains lots of scalar data potentially, thus loop through that.
          for(int i=0; i<datas.length; i+=3) {
            // Increase the unique key id by one every time, as it has to be unique.
            maxScalarId +=1;
            // Create the insert prepared statement to insert and upload the scalar data to the database.
            csvData = mCon.prepareStatement("insert into scalar_data (id, sensor_id, date_created, value) values (?,?,TO_DATE(?,'DD/MM/YYYY HH24:MI:SS'),?)");
            csvData.setInt(1, maxScalarId);
            csvData.setInt(2, Integer.parseInt(datas[i]));
            csvData.setString(3, datas[i+1]);
            csvData.setFloat(4, Float.parseFloat(datas[i+2]));
            csvData.executeUpdate();
            // Close the prepared statement so a new one can be created safely in the next iteration.
            if(csvData != null) 
              csvData.close();
          }
        }
        
        // Submit/save all changes.
        mCon.commit();
        
        // Notify success
        if(!imageBase64Input.isEmpty())
          out.println("Image Data successfully submitted!<br>");
        if(!audioBase64Input.isEmpty())
          out.println("Audio Data successfully submitted!<br>");
        if(!csvFileContent.isEmpty())
          out.println("Batch Scalar Data successfully submitted!<br>");

        // Notify if nothing was contained in any of the dataUrl.
	    if((csvFileContent.isEmpty())&&(audioBase64Input.isEmpty())&&(imageBase64Input.isEmpty()))
	      out.println("No files chosen to upload<br>");

        // automatic redirect to the upload page.	
        out.println("You will be redirected in 3 seconds.");
        String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"upload.html\"; \',3000);</script>";
        out.println(redirectCode);
        
      } catch(SQLException ex) {
        
          if (debug)
            //out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
	    out.println("Something went wrong. Please check your data and make sure that your sensor exists and all data is in the required format, and try again. If you can still not find the problem, please contact your system administrator.");
          System.err.println("SQLException: " + ex.getMessage());

          // something went wrong thus roll back.
          if(mCon != null)
            mCon.rollback();
          
      } finally {
                
        // close the result set table, the statements and prepared statements
        // and set the connection back to auto commit and close the connection.
        if(maxIdValues != null)
          maxIdValues.close();
        if(maxIdVals != null)
          maxIdVals.close();
        if(wavData != null)
          wavData.close();
        if(jpgData != null)
          jpgData.close();
        if(csvData != null)
          csvData.close();
        if(mCon != null) {
          mCon.setAutoCommit(Boolean.TRUE);
          mCon.close();
        }
        
      }
    %>
  </div>
</div>
  </body>
</html>
