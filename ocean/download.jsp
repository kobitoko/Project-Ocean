<%@ page import="java.util.*, java.sql.* "%>
<!doctype html>
<html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<head>
<meta charset="utf-8">
<title>Ocean Observation System</title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'scientist';</script>
 <body style="background:lightblue;">
 
  <div id='content'>
  
  <script> 
  function closing() {
    window.self.close();
  }
  </script>
  
    <%
      // Boolean to whether or not display/print the SQL errors in the resulting html file.
      Boolean debug = Boolean.TRUE;
      
      // Connecting to Ualberta's oracle server.
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      // The oracle account to use.
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
      
      // Retrieving all the parameters passed via POST from previous page.
      Integer downloadId = Integer.parseInt(request.getParameter("downloadid"));
      String downloadType = request.getParameter("downloadtype");
      
      // Variable to store connection and prepared statements
      Connection mCon = null;
      PreparedStatement getBlob = null;
      ResultSet rs = null;
      
      // actually log in and perform statements
      try{
        // Create a connection
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        
        // Variable to store the blob containing the file.
        Blob blob = null;

        // String storing the html elements that will be printed later.
        String dataUrl = "";
        String closeButton = "<button onClick=\"closing()\">Close.</button>  <script> function closing() {window.self.close();}</script>";
        String somethingWrong = "<B>Sorry something went wrong, could not retrieve the file. </B><br>" + closeButton;
        
        // Checks whether the download is an image or audio and creates a prepared statement accordingly.
        if(downloadType.compareTo("image") == 0) {
          getBlob = mCon.prepareStatement("select recoreded_data from images where image_id=?");
          getBlob.setInt(1, downloadId.intValue());
        } else if(downloadType.compareTo("audio") == 0) {
          getBlob = mCon.prepareStatement("select recorded_data from audio_recordings where recording_id=?");
          getBlob.setInt(1, downloadId.intValue());
        } else {
          // Something must've gone really wrong! This should never happen.
        }
        
        // Check if the prepared statement is actually set.
        if(getBlob == null) {
          out.println(somethingWrong);
        }
        // Retrieve the result table from the executed prepared statement and store it.
        rs = getBlob.executeQuery();
        
        // if the result table has a valid row, retrieve the blob and store it.
        if(rs.next()) {
          blob = rs.getBlob(1);
          
          if(blob != null) {
            // the byte array containing the blob's bytes.
            byte[] imgByte = blob.getBytes((long) 1, (int) blob.length());
            // decode the byte array into the UTF-8 character format string.
            dataUrl = new String(imgByte, "UTF-8");
            
        	//forcing download taken from http://stackoverflow.com/questions/11353425/force-a-browser-to-save-file-as-after-clicking-link
            if(downloadType.compareTo("image") == 0) {
              // This blob contained an image and it's dataUrl string will be set into the html code accordingly.
              String imageDl = "<br><b><a id=\"dwnld\" href=\""+dataUrl+"\" download=\"sensor_image_id"+downloadId.toString()+".jpeg\" >Click here to download</a> the image.</b><br>";
              out.println(imageDl);
              out.println("<br>" + closeButton + "<br>");
              // Displaying the Image in the browser as a nice side thing 
              // (however this will cause this html to be about twice as big as of just the original image file, which is kind of bad for bandwidth).
    		  out.println("<img src='"+dataUrl+"'>");
    		  
    		} else if(downloadType.compareTo("audio") == 0) {
              // This blob contained an audio data and it's dataUrl string will be set into the html code accordingly.
    		  String audioDl = "<b><br><a id=\"dwnld\" href=\""+dataUrl+"\" download=\"sensor_audio_id"+downloadId.toString()+".wav\" >Click here to download</a> the audio file.</b><br>";
    		  out.println(audioDl);
    		  out.println("<br>" + closeButton + "<br>");
    		}
          } else {
            // The retrieved blob from the result table is empty/null.
            out.println(somethingWrong);
          }
        } else {
          // The result table is empty.
          out.println(somethingWrong);
        }
        
      } catch(SQLException ex) {
        
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          
      } finally {
        
        // close the result set table, the prepared statement, and the connection.
        
        if(rs != null)
          rs.close();
        
        if(getBlob != null)
          getBlob.close();
          
        if(mCon != null) {
          mCon.setAutoCommit(Boolean.TRUE);
          mCon.close();
        }
        
      }
      
    %>
  
  </div>

</body>
</html>
