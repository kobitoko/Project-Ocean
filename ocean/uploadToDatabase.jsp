<!--input-->
<%@ page import="java.util.*, java.sql.*, java.io.*, java.text.DateFormat"%>
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
      Integer imageSensorId = Integer.parseInt((request.getParameter("jpgsensorid")));
      java.sql.Date imageDateCreated = java.sql.Date.valueOf(request.getParameter("jpgdatecreated"));
      String imageDescription = request.getParameter("jpgdescription");
      
      String audioBase64Input = request.getParameter("audiofileput");
      Integer audioSensorId = Integer.parseInt((request.getParameter("wavsensorid")));
      java.sql.Date audioDateCreated = java.sql.Date.valueOf(request.getParameter("wavdatecreated"));
      Integer audioLength = Integer.parseInt((request.getParameter("wavlength")));
      String audioDescription = request.getParameter("wavdescription");
      
      String csvFileContent = request.getParameter("csvfileput");
      
      //printing text data.
      //System.err.println("image Base64Data: " + imageBase64Input + "\n\n audio Base64Data: " + audioBase64Input + "\n\n csv textData: " + csvFileContent + "\n\n");
      
      // there just pass the variable "dataurl" that will contain something like data:audio/wav;base64,UklGRgQj
      // and in the jsp to encode it from base64 
      // http://stackoverflow.com/questions/11472731/base64-inputstream-to-string
      // resize image http://stackoverflow.com/questions/244164/how-can-i-resize-an-image-using-java
      
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
      
      // taken from http://stackoverflow.com/questions/782178/how-do-i-convert-a-string-to-an-inputstream-in-java
      InputStream jpgStream = new ByteArrayInputStream(imageBase64Input.getBytes("UTF-8"));
      InputStream wavStream = new ByteArrayInputStream(audioBase64Input.getBytes("UTF-8"));
      
      // then do setBlob(int parameterIndex, InputStream inputStream, long length)
      
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
      PreparedStatement wavData = null;
      PreparedStatement jpgData = null;
      PreparedStatement csvData = null;
      
      // actually log in and perform statements
      try{
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        // some wav tutorial/reference http://www.ibmpressbooks.com/articles/article.asp?p=1146304&seqNum=3
        // wav another https://social.msdn.microsoft.com/Forums/en-US/e332e3cf-1dc4-4b22-af50-efa13eb4e4c4/saving-a-wav-file-in-sqlsever?forum=adodotnetdataproviders
        // wav https://docs.oracle.com/javase/7/docs/api/javax/sound/sampled/package-summary.html
        // jpg https://docs.oracle.com/javase/tutorial/2d/images/loadimage.html
        // csv https://en.wikipedia.org/wiki/Comma-separated_values
       
        //wavBlob = mCon.prepareStatement("insert into audio_recordings");
        
        // for getting 0 number when max value of id in table is nothing (table empty) http://stackoverflow.com/questions/15475059/how-to-treat-max-of-empty-table-as-0-instead-of-null
        String queryMaxIdValues = "select coalesce(MAX(i.image_id), 0), coalesce(MAX(a.recording_id), 0), coalesce(MAX(d.id), 0) from images i, audio_recordings a, scalar_data d";        
        
        maxIdVals = maxIdValues.executeQuery(queryMaxIdValues);
        maxIdVals.first();
        Integer maxImageId = Integer.valueOf(maxIdVals.getInt(1));
        Integer maxAudioId = Integer.valueOf(maxIdVals.getInt(2));
        Integer maxScalarId = Integer.valueOf(maxIdVals.getInt(3));
        
        
        
        
        // later for date from csvData    
        //to split strings:
        String regex = ".*,.*,.*\n";
        String regexDelimiters = ",\n";
        
        // http://docs.oracle.com/javase/7/docs/api/java/text/DateFormat.html
        DateFormat df = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT);
        try{
          java.util.Date utilDate = df.parse("16/08/2015 15:31:58");
        } catch(ParseException e) {
          //Date could not be parsed.
        }
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
        
        /*----------------------------------------
        CREATE TABLE sensors(
            sensor_id    int,
            location     varchar(64),
            sensor_type  char(1),
            description  varchar(128),
            CHECK(sensor_type in ('a', 'i', 's')),
            PRIMARY KEY(sensor_id)
        ) tablespace c391ware;
        audio----------------------------------------
        CREATE TABLE audio_recordings(
            recording_id int,
            sensor_id int,
            date_created date,
            length int,
            description varchar(128),
            recorded_data blob,
            PRIMARY KEY(recording_id),
            FOREIGN KEY(sensor_id) REFERENCES sensors
        ) tablespace c391ware;
        image----------------------------------------
        CREATE TABLE images(
            image_id int,
            sensor_id int,
            date_created date,
            description varchar(128),
            thumbnail blob,
            recoreded_data blob,
            PRIMARY KEY(image_id),
            FOREIGN KEY(sensor_id) REFERENCES sensors
        ) tablespace c391ware;
        scalar----------------------------------------
        CREATE TABLE scalar_data(
            id int,
            sensor_id int,
            date_created date,
            value float,
            PRIMARY KEY(id),
            FOREIGN KEY(sensor_id) REFERENCES sensors
        ) tablespace c391ware;
        */
               
       
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          // something went wrong thus roll back.
          mCon.rollback();
      } finally {
        maxIdValues.close();
        maxIdVals.close();
        wavData.close();
        jpgData.close();
        csvData.close();
        mCon.close();
      }
    %>
  
  </body>
</html>
