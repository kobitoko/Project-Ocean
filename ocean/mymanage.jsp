<!doctype html>
<script>

</script>
<html>
<head>
<meta charset="utf-8">
<title></title>
</head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script>permission = 'universal';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
 <div id='content'>

 <div class="inline" style="border-style:inset;width:23%;">
    <form action="modifyAccount.jsp" name="modform" method="post">
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <table style="width:100%;border-style:inset";>
     <tr><td> <p style="display:inline">First Name: </p></td><td><input type="text" id="fname" name="fname" maxlength="32" value="" required placeholder="First Name"><br></td></tr>
      <tr><td><p style="display:inline">Family Name: </p></td><td><input type="text" name="lname" maxlength="32" required placeholder="Last Name"><br></td></tr>
      <tr><td><p style="display:inline">Address: </p></td><td><input type="text" name="address" maxlength="32" required placeholder="Address"><br></td></tr>
      <tr><td><p style="display:inline">Email: </p></td><td><input type="text" name="email" maxlength="32" required placeholder="Email"><br></td></tr>
      <tr><td><p style="display:inline">Phone: </p></td><td><input type="text" name="phone" maxlength="32" required placeholder="Phone"><br></td></tr>
      <tr><td><p style="display:inline">Change Password: </p></td><td><input type="password" name="pass" min="0" required placeholder="New Password"><br></td></tr>
      </table>
      User's role is:<br>
     
      <input type="submit" name="submit" value="Update">
    </form>
 </div>
 </div>
</body>
</html>
<script>
	document.getElementById("fname").value = getPID();
</script>
