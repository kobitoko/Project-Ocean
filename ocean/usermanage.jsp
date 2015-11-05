<%@ page import="java.util.*, java.sql.*"%>
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
            
            // Prints username, pid, and role
            out.print( "<tr>" + open + usr + close + open + pid.toString() + close + open + role + close);
            
            // prints modify user section and delete user section
            //String delButton = "<form  action=\"removeThatAccount.jsp\" method=\"post\"> <center> <button type=\"submit\" name=\"userToDelete\" value=\"" + usr + "\">Delete</button> </center> </form>";
            String delButton = "<form onsubmit=\"if(!confirm(\'Are you sure you want to delete the user " + usr + "?\')){ return false;}\" action=\"removeThatAccount.jsp\" method=\"post\"> <center> <button onclick=\"confirmation()\" name=\"userToDelete\" value=\"" + usr + "\">Delete</button> </center>";
            String confirmJS = "<script>function confirmation() {if(confirm(\"Are you sure you want to delete the user \"" + usr + "\"?\")){form.submit()}  }</script>";
            out.println(open + close + open + delButton + close + "</form> </tr>");
            
          }
          
          stmnt.close();
          mCon.close();
          
      } catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());          
      }      
      %>
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
