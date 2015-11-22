<!doctype html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<html>
<style>
input[type=number]{
    width: 50px;
} 
</style>
<head>
<meta charset="utf-8">
<title>Ocean Observation System</title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script src="search.js"></script>
<script>permission = 'scientist';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
 <div id='content'>
 <p> Sensor Search:</p>
 <form action="executeSearch.jsp" method="post">
      <b>Enter search parameters:</b><br>
      <table style="width:50%;border-style:inset";>

     <tr><td> <p style="display:inline">Sensor Type: </p></td><td><input type="text" onblur="verifyTime()" id="stype" size="32" name="stype" maxlength="1"  placeholder="Sensor Type"><br></td></tr>
      <tr><td><p style="display:inline">Sensor Location: </p></td><td><input type="text" size="32" name="local" maxlength="64"  placeholder="Sensor Location"><br></td></tr>
      <tr><td><p style="display:inline">Keywords (exact string): </p></td><td><input size="32" type="text" name="key" maxlength="128"  placeholder="Keywords"><br></td></tr>
      <tr><td><p style="display:inline">Data Since: (dd/mm/yyyy hh:mm:ss)</p></td><td><input id="dateSince" type="text" pattern="[0-9]{2}[/][0-9]{2}[/][0-9]{4}[ ][0-9]{2}:[0-9]{2}:[0-9]{2}"><br></td></tr>
      <tr><td><p style="display:inline">Data Up Until: (dd/mm/yyyy hh:mm:ss) </p></td><td><input id="dateUntil" type="text" pattern="[0-9]{2}[/][0-9]{2}[/][0-9]{4}[ ][0-9]{2}:[0-9]{2}:[0-9]{2}"><br></td></tr>
     
      </table>
      <input type="submit" name="submit" value="Search!">
    </form>

</div>
</body>
</html>

