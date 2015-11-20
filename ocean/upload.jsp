<!--input-->
<%@ page import="java.util.*, java.sql.*, java.io.*"%>
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
      String audioBase64Input = request.getParameter("audiofileput");
      String csvFileContent = request.getParameter("csvfileput");
      
      System.err.println("JpgBase64: " + j + "\nwavBase64: " + a +"\ncsvBase64: " + c);
      
      
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
      
      /*
      File dirJpg = new File(j); 
      File dirWav = new File(a);
      
      int jpgFileLen = (int) dirJpg.length();
      
      int wavFileLen = (int) dirWav.length();

      int csvFileLen = (int) dirCSV.length();
      
      System.err.println("JpgBlob: " + Integer.valueOf(wavFileLen).toString() + " wavBlob: " + Integer.valueOf(wavFileLen).toString() +" csvBlob: " + Integer.valueOf(csvFileLen).toString() );
      
      FileInputStream jpgStream = new FileInputStream(dirJpg);
      FileInputStream wavStream = new FileInputStream(dirWav);
      */
      
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
  
      PreparedStatement wavBlob;
      PreparedStatement jpgBlob;
      PreparedStatement csvLoop;      
      
      // actually log in and perform statements
      try{
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        // some wav tutorial/reference http://www.ibmpressbooks.com/articles/article.asp?p=1146304&seqNum=3
        // wav another https://social.msdn.microsoft.com/Forums/en-US/e332e3cf-1dc4-4b22-af50-efa13eb4e4c4/saving-a-wav-file-in-sqlsever?forum=adodotnetdataproviders
        // wav https://docs.oracle.com/javase/7/docs/api/javax/sound/sampled/package-summary.html
        // jpg https://docs.oracle.com/javase/tutorial/2d/images/loadimage.html
        // csv https://en.wikipedia.org/wiki/Comma-separated_values
       
        //wavBlob = mCon.prepareStatement("insert into audio_recordings");
        
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
----------------------------------------*/
       
       
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          // something went wrong thus roll back.
          mCon.rollback();
      } finally {
       // revoke objects of all the stuff, its uploaded we don't need these blobs anymore 
       //revokeObjectURL(url : String) : undefined 
      }
    %>
  
  </body>
</html>
