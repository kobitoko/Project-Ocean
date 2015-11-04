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
 <p> Sensor Search:</p>
 <form action="createAccount.jsp" method="post">
      <b>Create new user:</b><br>
      <table style="width:50%;border-style:inset";>
      <tr><td><p style="display:inline">Sensor ID: </p></td><td><input type="text" size="32" name="sid" maxlength="128" required placeholder="Sensor ID"><br></td></tr>
     <tr><td> <p style="display:inline">Sensor Type: </p></td><td><input type="text" size="32" name="stype" maxlength="32" required placeholder="Sensor Type"><br></td></tr>
      <tr><td><p style="display:inline">Sensor Location: </p></td><td><input type="text" size="32" name="local" maxlength="32" required placeholder="Sensor Location"><br></td></tr>
      <tr><td><p style="display:inline">Keywords (comma seperated): </p></td><td><input size="32" type="key" name="address" maxlength="1024" required placeholder="Keywords"><br></td></tr>
      <tr><td><p style="display:inline">Data Since: (mm/dd/yyyy)</p></td><td><input size="32" type="datafrom" name="email" maxlength="32" required placeholder="Data Since"><br></td></tr>
      <tr><td><p style="display:inline">Data Up Until: (mm/dd/yyyy) </p></td><td><input size="32" type="datato" name="email" maxlength="32" required placeholder="Datil Up Until"><br></td></tr>
     
      </table>
      <input type="submit" name="submit" value="Search!">
    </form>

</div>
</body>
</html>
