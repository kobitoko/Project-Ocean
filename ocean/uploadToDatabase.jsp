<!--input-->
<%@ page import="java.util.*, java.sql.*, java.io.*, java.text.* "%>
<html>
  <head></head>
  <body>
    <%
    
      Boolean debug = Boolean.TRUE;
      
      // Get this user with the old userID and old PID to find the user in the first place. 
      String User = null;
      Integer PID = null;
      // Based on tutorials at http://www.tutorialspoint.com/
      Cookie cookie = null;
      Cookie[] cookies = null;
      String comppid = "modpid";
      String compname = "modname";
      cookies = request.getCookies();
      if( cookies != null ){
        for (Integer i = 0; i < cookies.length; i++){
          cookie = cookies[i];
          if(cookie.getName().equals(comppid)){PID = Integer.parseInt(cookie.getValue());}
          if(cookie.getName().equals(compname)){User = cookie.getValue();}
         }
      }
      
      String imageBase64Input = request.getParameter("jpgfileput");
      String imageThumbBase64Input = request.getParameter("jpgthumbnailfileput");
      Integer imageSensorId = Integer.parseInt((request.getParameter("jpgsensorid")));
      String imageTimeCreated = request.getParameter("jpgtimecreated");
      String imageDateCreated = request.getParameter("jpgdatecreated");
      String imageDescription = request.getParameter("jpgdescription");
      
      String audioBase64Input = request.getParameter("audiofileput");
      Integer audioSensorId = Integer.parseInt((request.getParameter("wavsensorid")));
      String audioTimeCreated = request.getParameter("wavtimecreated");
      String audioDateCreated = request.getParameter("wavdatecreated");
      Integer audioLength = Integer.parseInt((request.getParameter("wavlength")));
      String audioDescription = request.getParameter("wavdescription");
      
      String csvFileContent = request.getParameter("csvfileput");
      
      //printing text data.
      //System.err.println("image Base64Data: " + imageBase64Input + "\n\n audio Base64Data: " + audioBase64Input + "\n\n csv textData: " + csvFileContent + "\n\n");
      
      // later for downloading stuff http://stackoverflow.com/questions/7115379/how-i-do-get-an-image-blob-from-jsp-to-javascript
      // and 
      //ByteArrayOutputStream byteArrayBitmapStream = new ByteArrayOutputStream();
      //image.compress(Bitmap.CompressFormat.JPEG, COMPRESSION_QUALITY, byteArrayBitmapStream);
      //byte[] b = byteArrayBitmapStream.toByteArray();
      //return Base64.encodeToString(b, Base64.DEFAULT);
      // perhaps needed this encode if wanting to  resize.
      // and for preparedstamementVar.setBinaryStream(2, inputStreamVar, fileLength);
      // so need to convert it to File? since in html can do src=theStringBase64File can assign file to it too?
      // or need to decode the base64 to bytestream? idk??
      // for download, put the thing in the url to open file e.g. in the url bar data:audio/wav;base64,UklGRu... 
      // to download can use http://stackoverflow.com/questions/10473932/browser-html-force-download-of-image-from-src-dataimage-jpegbase64
      
      // taken from http://stackoverflow.com/questions/782178/how-do-i-convert-a-string-to-an-inputstream-in-java
      byte[] imageByteArr = imageBase64Input.getBytes("UTF-8");
      byte[] imageThumbByteArr = imageThumbBase64Input.getBytes("UTF-8");
      byte[] audioByteArr = audioBase64Input.getBytes("UTF-8");
      
      int imageByteArrSize = imageByteArr.length;
      int imageThumbByteArrSize = imageThumbByteArr.length;
      int audioByteArrSize = audioByteArr.length;
      
      InputStream jpgStream = new ByteArrayInputStream(imageByteArr);
      InputStream jpgThumbStream = new ByteArrayInputStream(imageThumbByteArr);
      InputStream wavStream = new ByteArrayInputStream(audioByteArr);
      
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
        
        //------------> FIND ERROR  invalid host/bind variable name!!!!!!
        
        // some wav tutorial/reference http://www.ibmpressbooks.com/articles/article.asp?p=1146304&seqNum=3

        // csv https://en.wikipedia.org/wiki/Comma-separated_values
        
        // for getting 0 number when max value of id in table is nothing (table empty) http://stackoverflow.com/questions/15475059/how-to-treat-max-of-empty-table-as-0-instead-of-null
        String queryMaxIdValues = "select coalesce(MAX(i.image_id), 0), coalesce(MAX(a.recording_id), 0), coalesce(MAX(d.id), 0) from images i, audio_recordings a, scalar_data d";        
        
        maxIdValues = mCon.createStatement();
        maxIdVals = maxIdValues.executeQuery(queryMaxIdValues);
        maxIdVals.next();
        Integer maxImageId = Integer.valueOf(maxIdVals.getInt(1));
        Integer maxAudioId = Integer.valueOf(maxIdVals.getInt(2));
        Integer maxScalarId = Integer.valueOf(maxIdVals.getInt(3));
        
        jpgData = mCon.prepareStatement("insert into IMAGES (image_id, sensor_id, date_created, description, thumbnail, recoreded_data) values (?,?,TO_DATE(? ?,'DD/MM/YYYY HH:MI:SS'),?,?,?)");
        jpgData.setInt(1, maxImageId+1);
        jpgData.setInt(2, imageSensorId);
        jpgData.setString(3, imageDateCreated);
        jpgData.setString(4, imageTimeCreated);
        jpgData.setString(5, imageDescription);              
        // then do setBlob(int parameterIndex, InputStream inputStream, long length);
        jpgData.setBlob(6, jpgThumbStream, imageThumbByteArrSize);
        jpgData.setBlob(7, jpgStream, imageByteArrSize);
        jpgData.executeUpdate();
        
        wavData = mCon.prepareStatement("insert into audio_recordings (recording_id, sensor_id, date_created, length, description, recorded_data) values (?,?,TO_DATE(? ?,'DD/MM/YYYY HH:MI:SS'),?,?,?)");
        wavData.setInt(1, maxAudioId+1);
        wavData.setInt(2, audioSensorId);
        wavData.setString(3, audioDateCreated);
        wavData.setString(4, audioTimeCreated);
        wavData.setInt(5, audioLength);
        wavData.setString(6, audioDescription);              
        wavData.setBlob(7, wavStream, audioByteArrSize);
        wavData.executeUpdate();
        
        //to split strings using patterns from https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html#sum
        String regexDelimiters = "[,(\n$)]";
        String[] datas = csvFileContent.split(regexDelimiters);
        
        //System.err.print("len"+datas.length/3);
        
        for(int i=0; i<datas.length; i+=3) {
          //out.println(datas[i]+"_"+datas[i+1]+"_._"+datas[i+2]+"<br>");
          
          maxScalarId +=1;
          csvData = mCon.prepareStatement("insert into scalar_data (id, sensor_id, date_created, value) values (?,?,TO_DATE(?,'DD/MM/YYYY HH:MI:SS'),?)");
          csvData.setInt(1, maxScalarId);
          csvData.setInt(2, Integer.parseInt(datas[i]));
          csvData.setString(3, datas[i+1]);
          csvData.setFloat(4, Float.parseFloat(datas[i+2]));
          csvData.executeUpdate();
          if(csvData != null) 
            csvData.close();
        }

        // Submit all changes.
        mCon.commit();
       
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
