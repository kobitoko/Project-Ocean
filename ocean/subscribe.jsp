<!doctype html>
<html>
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
<div>
<b> My Subscriptions </b>
<form action="unsubSensor.jsp" id="unsubSensor" method="post">
<div>
<input  type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Unsubscribe to checked Sensors">
</div>
<table style="width:100%;border-style:inset";>
    <tr>
    <th>Sensor ID</th>
    <th>Location</th>
    <th>Sensor Type</th>
    <th>Description</th>
    <th>Unsubscirbe</th>
    </tr>
    <tr>
    <td>00001</td>
    <td>Zimbabwe</td>
    <td>Neon-plasma</td>
    <td>A shiny thing</td>
    <td><input style="width:100%"; type="checkbox" placeholder="Subscribe?"></td>
    </tr>
  	 </table>
     <input type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Unsubscribe to checked Sensors">
     </form>
</div>
<div style="border-style:inset;">
<p style="display:inline"><b>Directly add by Sensor ID</b></p><form action="subSensor.jsp" id="subSensor" method="post">
<input type="text" name="sid" maxlength="32" required placeholder="Sensor ID"><input type="submit" style="background-color:blue;color:white;" name="submit" value="Subscribe to Sensor">
     </form>
</form>

</div>
<br><br>
<div>
<b>Other Sensors</b>
<form action="subSensor.jsp" id="subSensor" method="post">
<input type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Subscribe to new Sensors">
<table style="width:100%;border-style:inset";>
    <tr>
    <th>Sensor ID</th>
    <th>Location</th>
    <th>Sensor Type</th>
    <th>Description</th>
    <th>Subscribe</th>
    </tr>
    <tr>
    <td>00002</td>
    <td>Zimbabwe</td>
    <td>Xenon-plasma</td>
    <td>A  slightly less shiny thing</td>
    <td><input style="width:100%"; type="checkbox" placeholder="Subscribe?"></td>
    </tr>
  	 </table>
    <input type="submit" style="position:relative;left:40%;background-color:blue;color:white;" name="submit" value="Subscribe to new Sensors">
     </form>
</div>
</div>
</body>
</html>
