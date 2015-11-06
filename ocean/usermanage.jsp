<%@ page import="java.util.*, java.sql.*"%>
<html>
  <head></head>
<link rel="stylesheet" type="text/css" href="oceanstyler.css">
<script src="imports.js"></script>
<script src="usermanage.js"></script>
<script>permission = 'admin';</script>
 <body style="background:lightblue;">
 <div id='header' style="height:50px;border-style:inset;"></div>
  <div id='content'>
 <div>
 <div class="inline" style="border-style:inset;width:20%;;">
    <form action="createAccount.jsp" method="post"name="addform' id="addform">
      <b>Create new user:</b><br>
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <input type="text" name="uid" maxlength="32" required placeholder="Username"><br>
      <input type="password" name="pass" maxlength="32" required placeholder="Password"><br>
      <input type="number" name="pid" min="0" required placeholder="Person ID"><br>
  User's role is:<br>
      <select id="addrole" form="addform">
      <option value="s">Scientist</option>
      <option value="d">Data Curator</option>
      <option value="a">Administrator</option>
      <select>
      <input type="submit" name="submit" value="Create!">
    </form>
    </div>
    
    <div class="inline" style="border-style:inset;width:50%;">
    <button onClick="modifyUser()" style="position:relative;left:40%;background-color:green;color:white;display:inline;"  value="Modify Checked User">Modify Checked User</button>
    <form action="removeThatAccount.jsp" method="post">
    <input style="position:relative;left:40%;background-color:blue;color:white;display:inline;" type="submit" name="submit" value="Remove Checked User">
    <table style="width:100%;border-style:inset";>
    <tr>
    <th>Username</th>
    <th>User ID</th>
    <th>Role</th>
    <th>Modify User</th>
    <th>Delete User</th>
    </tr>
    <tr>
       <%
      
      Boolean debug = Boolean.TRUE;
      String queryUsers = "select USER_NAME, ROLE, PERSON_ID, DATE_REGISTERED from USERS";
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      
      Connection mCon;
      Statement stmnt;
      PreparedStatement pstmnt;
      
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
      
      // actually log in and perform statements
      try {
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          stmnt = mCon.createStatement();
          
          ResultSet rset = stmnt.executeQuery(queryUsers);
          
          while(rset.next()) {
            String usr = rset.getString(1);
            String role = rset.getString(2);
            Integer pid = new Integer(rset.getInt(3));
            // not yet used is date.
            java.sql.Date dateReg = rset.getDate(4);
            
            if(role.equals("a")) {
              role = "Administrator";
            } else if (role.equals("s")) {
              role = "Scientist";
            } else if (role.equals("d")) {
              role = "Data Curator";
            }
            
            String open = "<td>";
            String close = "</td>";
	    String tropen = "<tr>";
	    String trclose = "</tr>";	
			
			String buttonmod = "<input type='radio' id='userToMod' name='userToMod' value='" + usr + ";;" + pid.toString() + ";;" + role +  "'>";
			
		
			String buttonrm = "<input type='radio' name='userToDelete' value='" + usr + "'>";
			
            out.println( tropen + open + usr + close + open + pid.toString() + close + open + role + close + open + buttonmod +  close + open + buttonrm + close);
            
          }
          
          stmnt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog: Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }      
      %>
    </tr>
  	 </table>
     <input style="position:relative;left:40%;background-color:blue;color:white;display:inline;" type="submit" name="submit" value="Remove Checked User">
     </form>
 <button onClick="modifyUser()" style="position:relative;left:40%;background-color:green;color:white;display:inline;"  value="Modify Checked User">Modify Checked User</button>
	</div>
    <div class="inline" style="border-style:inset;width:23%;">
    <b>Modify user:</b><br>
    <form action="modifyAccount.jsp" name="modform" method="post">
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <table style="width:100%;border-style:inset";>
      <tr><td><p style="display:inline">Username: </p></td><td><input type="text" id="moduid" name="uid" maxlength="32" required placeholder="Username"><br></td></tr>
     <tr><td> <p style="display:inline">First Name: </p></td><td><input type="text" name="fname" maxlength="32" required placeholder="First Name"><br></td></tr>
      <tr><td><p style="display:inline">Family Name: </p></td><td><input type="text" name="lname" maxlength="32" required placeholder="Last Name"><br></td></tr>
      <tr><td><p style="display:inline">Address: </p></td><td><input type="text" name="address" maxlength="32" required placeholder="Address"><br></td></tr>
      <tr><td><p style="display:inline">Email: </p></td><td><input type="text" name="email" maxlength="32" required placeholder="Email"><br></td></tr>
      <tr><td><p style="display:inline">Phone: </p></td><td><input type="text" name="phone" maxlength="32" required placeholder="Phone"><br></td></tr>
      <tr><td><p style="display:inline">User ID: </p></td><td><input id="modpid" type="number" name="pid" min="0" required placeholder="Person ID"><br></td></tr>
      <tr><td><p style="display:inline">Password Reset: </p></td><td><input type="password" name="pass" min="0" required placeholder="New Password"><br></td></tr>
      </table>
      User's role is:<br>
      <select id="modrole" form="modform">
      <option value="s">Scientist</option>
      <option value="d">Data Curator</option>
      <option value="a">Administrator</option>
      <select>
      <input type="submit" name="submit" value="Update">
    </form>
    </div>
    </div>
    </div>
  </body>
</html>
