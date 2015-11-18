<!--input-->
<%@ page import="java.util.*, java.sql.*, java.io.*. "%>
<html>
  <head></head>
  <body>
    <%
    
      Boolean debug = Boolean.TRUE;
      
      // Get this user with the old userID and old PID to find the user in the first place. 
      String User = null;
      Integer PID = null;
      //Based on tutorials at http://www.tutorialspoint.com/
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
      
      String dirJpg = request.getParameter("jpgfile");
      String dirWav = request.getParameter("audiofile");
      String dirCSV = request.getParameter("csvfile");
      
      java.io.File wavFile = new java.io.File(dirWav);
      int wavFileLen = (int) wavFile.length();
      
      java.io.File jpgFile = new java.io.File(dirJpg);
      int jpgFileLen = (int) jpgFile.length();

      //java.io.File csvFile = new java.io.File(dirCSV);
      //int csvFileLen = (int) csvFile.length();
      
      // Taken from http://stackoverflow.com/questions/326390/how-to-create-a-java-string-from-the-contents-of-a-file
      ArrayList<String> csvLines = Files.readAllLines(Path.resolve(dirCSV), StandardCharsets.UTF_8));
      
      java.io.InputStream wavStream = new java.io.FileInputStream(wavFile);
      java.io.InputStream jpgStream = new java.io.FileInputStream(jpgFile);
      
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
       
      }
    %>
  
  </body>
</html>
