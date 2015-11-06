<html>
  <head></head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'admin';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
 <div>
 <div class="inline" style="border-style:inset;width:20%;;">
    <form action="createSensor.jsp" id="sensform" method="post">
      <b>Create new sensor:</b><br>
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <input type="text" name="sid" maxlength="32" required placeholder="Sensor ID"><br>
      <input type="text" name="local" maxlength="32" required placeholder="Location"><br>
     	<input type="text" name="stype" maxlength="32" required placeholder="Type"><br>
     	<textarea cols="32" form ="sensform" rows="6" name="sdesc" required placeholder="Description"></textarea><br>
      <input type="submit" name="submit" value="Create!">
    </form>
    </div>
    <div class="inline" style="border-style:inset;width:79%;">
    <table style="width:100%;border-style:inset";>
    <tr>
    <th>Sensor ID</th>
    <th>Location</th>
    <th>Sensor Type</th>
    <th>Description</th>
    <th>Remove Sensor</th>
    </tr>
    <tr>
    <td>00001</td>
    <td>Zimbabwe</td>
    <td>Neon-plasma</td>
    <td>A shiny thing</td>
    <td><button style="width:100%;">Remove Sensor 00001</button></td>
    </tr>
  	 </table>
	</div>
    
    </div>
    </div>
  </body>
</html>
