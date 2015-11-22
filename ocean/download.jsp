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
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
  
    <%
    
      
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
      
      
    %>
  
  </div>

</body>
</html>
