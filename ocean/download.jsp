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
      Boolean debug = Boolean.TRUE;
            
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
      
      Integer downloadId = Integer.parseInt(request.getParameter("downloadid"));
      String downloadType = request.getParameter("downloadtype");
      
      Connection mCon = null;
      PreparedStatement getBlob = null;
      ResultSet rs = null;
      
     
      
      // actually log in and perform statements
      try{
        mCon = DriverManager.getConnection(mUrl, mUser, mPass);
        
        Blob blob = null;

        String dataUrl = "";
        String closeButton = "<button onClick=\"closing()\">Close.</button>  <script> function closing() {window.self.close();}</script>";
        String somethingWrong = "<B>Sorry something went wrong, could not retrieve the image. </B>" + closeButton;
        
        if(downloadType.compareTo("image") == 0) {
          getBlob = mCon.prepareStatement("select recoreded_data from images where image_id=?");
          getBlob.setInt(1, downloadId.intValue());
        } else if(downloadType.compareTo("audio") == 0) {
          getBlob = mCon.prepareStatement("select recorded_data from audio_recordings where recording_id=?");
          getBlob.setInt(1, downloadId.intValue());
        } else {
          // something must've gone really wrong! This should never happen.
        }
        
        if(getBlob == null) {
          out.println(somethingWrong);
        }
        rs = getBlob.executeQuery();
        
        if(rs.next()) {
          blob = rs.getBlob(1);
          
          if(blob != null) {
            byte[] imgByte = blob.getBytes((long) 1, (int) blob.length());
            dataUrl = new String(imgByte, "UTF-8");
        	//forcing download taken from http://stackoverflow.com/questions/11353425/force-a-browser-to-save-file-as-after-clicking-link

            if(downloadType.compareTo("image") == 0) {
              String imageDl = "<br><b><a id=\"dwnld\" href=\""+dataUrl+"\" download=\"sensor_image_id"+downloadId.toString()+".jpeg\" onClick=\"setTimeout(closing, 3000)\" >Click here to download</a> the image.</b><br>This tab will automatically close 3 seconds after clicking the download link.<br>";
              out.println(imageDl);
              out.println(closeButton + "<br>");
    		  out.println("<img src='"+dataUrl+"'>");
    		  
    		} else if(downloadType.compareTo("audio") == 0) {
    		  String audioDl = "<b><br><a id=\"dwnld\" href=\""+dataUrl+"\" download=\"sensor_audio_id"+downloadId.toString()+".wav\" onClick=\"setTimeout(closing, 3000)\">Click here to download</a> the audio file.</b><br>This tab will automatically close 3 seconds after clicking the download link.";
    		  out.println(audioDl);
    		  out.println("<br>" + closeButton + "<br>");
    		}
          } else {
            out.println(somethingWrong);
          }
        } else {
          out.println(somethingWrong);
        }
        
      } catch(SQLException ex) {
        
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
          // something went wrong thus roll back.
          
      } finally {
        
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
