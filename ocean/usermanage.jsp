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
    <form action="createAccount.jsp" method="post">
      <b>Create new user:</b><br>
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <input type="text" name="uid" maxlength="32" required placeholder="Username"><br>
      <input type="text" name="pass" maxlength="32" required placeholder="Password"><br>
      User's role is:<br>
      <input type="radio" name="role" required value="s" checked> Scientist <br>
      <input type="radio" name="role" required value="d"> Data curator <br>
      <input type="radio" name="role" required value="a"> Administrator <br>
      <input type="number" name="pid" min="0" required placeholder="Person ID"><br>
      <input type="submit" name="submit" value="Create!">
    </form>
    </div>
    <div class="inline" style="border-style:inset;width:50%;">
    <table style="width:100%;border-style:inset";>
    <tr>
    <th>Username</th>
    <th>User ID</th>
    <th>Role</th>
    <th>Modify User</th>
    <th>Delete User</th>
    </tr>
    <tr>
    <td>jcadek</td>
    <td>00001</td>
    <td>Administrator</td>
    
    
    </tr>
  	 </table>
	</div>
    <div class="inline" style="border-style:inset;width:23%;">
    <b>Modify user:</b><br>
    <form action="modifyAccount.jsp" method="post">
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <table style="width:100%;border-style:inset";>
      <tr><td><p style="display:inline">Username: </p></td><td><input type="text" name="uid" maxlength="32" required placeholder="Username"><br></td></tr>
     <tr><td> <p style="display:inline">First Name: </p></td><td><input type="text" name="fname" maxlength="32" required placeholder="First Name"><br></td></tr>
      <tr><td><p style="display:inline">Family Name: </p></td><td><input type="text" name="lname" maxlength="32" required placeholder="Last Name"><br></td></tr>
      <tr><td><p style="display:inline">Address: </p></td><td><input type="text" name="address" maxlength="32" required placeholder="Address"><br></td></tr>
      <tr><td><p style="display:inline">Email: </p></td><td><input type="text" name="email" maxlength="32" required placeholder="Email"><br></td></tr>
      <tr><td><p style="display:inline">Phone: </p></td><td><input type="text" name="phone" maxlength="32" required placeholder="Phone"><br></td></tr>
      <tr><td><p style="display:inline">User ID: </p></td><td><input type="number" name="pid" min="0" required placeholder="Person ID"><br></td></tr>
      <tr><td><p style="display:inline">Password Reset: </p></td><td><input type="number" name="pass" min="0" required placeholder="New Password"><br></td></tr>
      </table>
      User's role is:<br>
      <input type="radio" name="role" required value="s" checked> Scientist <br>
      <input type="radio" name="role" required value="d"> Data Curator <br>
      <input type="radio" name="role" required value="a"> Administrator <br>
      
      <input type="submit" name="submit" value="Update">
    </form>
    </div>
    </div>
    </div>
  </body>
</html>
