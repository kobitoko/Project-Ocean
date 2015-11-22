<!--input-->
<%@ page import="java.util.*, java.sql.*, java.io.*, java.text.* "%>
<html>
  <head></head>
  <body style="background:lightblue;">
    <%
    
      Boolean debug = Boolean.TRUE;
      
      String imageBase64Input = request.getParameter("jpgfileput");
      String imageThumbBase64Input = request.getParameter("jpgthumbnailfileput");
      Integer imageSensorId = 0;
      if(!(request.getParameter("jpgsensorid")).isEmpty())
        imageSensorId = Integer.parseInt((request.getParameter("jpgsensorid")));
      String imageTimeCreated = request.getParameter("jpgtimecreated");
      String imageDateCreated = request.getParameter("jpgdatecreated");
      String imageDescription = request.getParameter("jpgdescription");
      
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
      
      String csvFileContent = request.getParameter("csvfileput");
      
      // taken from http://stackoverflow.com/questions/782178/how-do-i-convert-a-string-to-an-inputstream-in-java
      
      byte[] imageByteArr = null;
      byte[] imageThumbByteArr = null;
      int imageByteArrSize = 0;
      int imageThumbByteArrSize = 0;
      InputStream jpgStream = null;
      InputStream jpgThumbStream = null;
      
      byte[] audioByteArr = null;
      int audioByteArrSize = 0;
      InputStream wavStream = null;
       
      if(!imageBase64Input.isEmpty()) {
        imageByteArr = imageBase64Input.getBytes("UTF-8");
        imageThumbByteArr = imageThumbBase64Input.getBytes("UTF-8");
        imageByteArrSize = imageByteArr.length;
        imageThumbByteArrSize = imageThumbByteArr.length;
        jpgStream = new ByteArrayInputStream(imageByteArr);
        jpgThumbStream = new ByteArrayInputStream(imageThumbByteArr);
      }
      if(!audioBase64Input.isEmpty()) {
        audioByteArr = audioBase64Input.getBytes("UTF-8");
        audioByteArrSize = audioByteArr.length;
        wavStream = new ByteArrayInputStream(audioByteArr);
      }
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
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
      
      Connection mCon = null;
      Statement maxIdValues = null;
      ResultSet maxIdVals = null;
      PreparedStatement jpgData = null;
      PreparedStatement wavData = null;
      PreparedStatement csvData = null;
      
      // actually log in and perform statements
      try{
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        mCon.setAutoCommit(Boolean.FALSE);
        
        // for getting 0 number when max value of id in table is nothing (table empty) http://stackoverflow.com/questions/15475059/how-to-treat-max-of-empty-table-as-0-instead-of-null
        String queryMaxIdValues = "select coalesce(MAX(i.image_id), 0), coalesce(MAX(a.recording_id), 0), coalesce(MAX(d.id), 0) from images i, audio_recordings a, scalar_data d";
        maxIdValues = mCon.createStatement();
        maxIdVals = maxIdValues.executeQuery(queryMaxIdValues);
        maxIdVals.next();
        Integer maxImageId = Integer.valueOf(maxIdVals.getInt(1));
        Integer maxAudioId = Integer.valueOf(maxIdVals.getInt(2));
        Integer maxScalarId = Integer.valueOf(maxIdVals.getInt(3));
        
        if(!imageBase64Input.isEmpty()) {
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
        
        if(!audioBase64Input.isEmpty()) {
          wavData = mCon.prepareStatement("insert into audio_recordings (recording_id, sensor_id, date_created, length, description, recorded_data) values (?,?,TO_DATE(?,'DD/MM/YYYY HH24:MI:SS'),?,?,?)");
          wavData.setInt(1, maxAudioId+1);
          wavData.setInt(2, audioSensorId);
          wavData.setString(3, audioDateCreated + " " + audioTimeCreated);
          wavData.setInt(4, audioLength);
          wavData.setString(5, audioDescription);              
          wavData.setBlob(6, wavStream, audioByteArrSize);
          wavData.executeUpdate();
        }  
        
        if(!csvFileContent.isEmpty()) {
          // csv https://en.wikipedia.org/wiki/Comma-separated_values
          //to split strings using patterns from https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html#sum
          String regexDelimiters = "[,(\n$)]";
          String[] datas = csvFileContent.split(regexDelimiters);
          
          for(int i=0; i<datas.length; i+=3) {
            //out.println(datas[i]+"_"+datas[i+1]+"_._"+datas[i+2]+"<br>");
            maxScalarId +=1;
            csvData = mCon.prepareStatement("insert into scalar_data (id, sensor_id, date_created, value) values (?,?,TO_DATE(?,'DD/MM/YYYY HH24:MI:SS'),?)");
            csvData.setInt(1, maxScalarId);
            csvData.setInt(2, Integer.parseInt(datas[i]));
            csvData.setString(3, datas[i+1]);
            csvData.setFloat(4, Float.parseFloat(datas[i+2]));
            csvData.executeUpdate();
            if(csvData != null) 
              csvData.close();
          }
        }
        
        // Submit all changes.
        mCon.commit();
        
        // Notify success
        if(!imageBase64Input.isEmpty())
          out.println("Image Data successfully submitted!<br>");
        if(!audioBase64Input.isEmpty())
          out.println("Audio Data successfully submitted!<br>");
        if(!csvFileContent.isEmpty())
          out.println("Batch Scalar Data successfully submitted!<br>");
	if((csvFileContent.isEmpty())&&(audioBase64Input.isEmpty())&&(imageBase64Input.isEmpty()))
	  out.println("No files chosen to upload<br>");
	
        out.println("You will be redirected in 3 seconds.");
        String redirectCode = "<script language=\"javascript\" type=\"text/javascript\">window.setTimeout(\'window.location=\"upload.html\"; \',3000);</script>";
        out.println(redirectCode);
        
      } catch(SQLException ex) {
        
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          // something went wrong thus roll back.
          if(mCon != null)
            mCon.rollback();
          
      } finally {
        
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
  
  </body>
</html>
