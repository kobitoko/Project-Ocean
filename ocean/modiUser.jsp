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
<div class="inline" style="border-style:inset;width:23%;">
    <b>Modify user:</b><br>
    <p id="grabPerson"></p>
 <%

 Boolean debug = Boolean.TRUE;
      
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "satyabra";
      String mPass = "adasfa42";
      Integer maxpid = 0;
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
	try{
		String getMaxPID = "select MAX(PERSON_ID) from USERS";
		mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          	stmnt = mCon.createStatement();
          
         	 ResultSet rset2 = stmnt.executeQuery(getMaxPID);
		while(rset2.next()) {
		  maxpid = new Integer(rset2.getInt(1)) + 1;
		}
	stmnt.close();
          mCon.close();
          

  	} catch(SQLException ex) {
          if (debug)
            out.println("<BR>-debugLog: Received a SQLException: " + ex.getMessage());
          System.err.println("SQLException: " + ex.getMessage());
      }  

Integer pid = Integer.parseInt(request.getParameter("modpid"));
String user = request.getParameter("moduid");
String role = request.getParameter("modrole");
String fname = "";
String lname = "";
String add = "";
String email = "";
String phone = "";

String queryMod = "select FIRST_NAME, LAST_NAME, ADDRESS, EMAIL, PHONE from PERSONS where PERSON_ID='" + pid + "'";
try{mCon = DriverManager.getConnection(mUrl, mUser, mPass);
stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rset = stmnt.executeQuery(queryMod);
if(rset.next()){
	fname = rset.getString(1);
	lname = rset.getString(2);
	add = rset.getString(3);
	email = rset.getString(4);
	phone = rset.getString(5);

	stmnt.close();
          mCon.close();
} else {
	out.println("Something went wrong.");
}} catch(SQLException ex) {if (debug)out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());System.err.println("SQLException: " + ex.getMessage());}%>
    <form action="modifyAccount.jsp" name="modform" method="post">
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <table style="width:100%;border-style:inset";>
      <tr><td><p style="display:inline">Username: </p></td><td><input type="text" id="moduid" value ="<%= user%>" name="uid" maxlength="32" required placeholder="Username"><br></td></tr>
     <tr><td> <p style="display:inline">First Name: </p></td><td><input type="text" value="<%= fname%>" name="fname" maxlength="32" required placeholder="First Name"><br></td></tr>
      <tr><td><p style="display:inline">Family Name: </p></td><td><input type="text" value="<%= lname%>" name="lname" maxlength="32" required placeholder="Last Name"><br></td></tr>
      <tr><td><p style="display:inline">Address: </p></td><td><input type="text" name="address" value="<%= add%>" maxlength="32" required placeholder="Address"><br></td></tr>
      <tr><td><p style="display:inline">Email: </p></td><td><input type="text" name="email" maxlength="32" value="<%= email%>" required placeholder="Email"><br></td></tr>
      <tr><td><p style="display:inline">Phone: </p></td><td><input type="text" name="phone" maxlength="32" value="<%= phone%>" required placeholder="Phone"><br></td></tr>
	 <tr><td><p style="display:inline">Person ID: </p></td><td><input id="modpid" type="number" value="<%= pid%>" name="pid" min="0" maxlength="38" required placeholder="Person ID"><br></td></tr>
      <tr><td><p style="display:inline">Password Reset: </p></td><td><input type="password" name="pass" min="0" required placeholder="New Password"><br></td></tr>
 <tr><td><p style="display:inline">Old Username: </p></td><td><input type="text" id="ouid" value ="<%= user%>" name="uid" maxlength="32" required placeholder="Username" disabled><br></td></tr>
<tr><td><p style="display:inline">Old PID: </p></td><td><input id="opid" type="number" value="<%= pid%>" name="pid" min="0" maxlength="38" required placeholder="Person ID" disabled><br></td></tr>
<tr><td><p style="display:inline">New Role: </p></td><td><input id="newrole" type="text" value="<%= role%>" name="pid" min="0" maxlength="38" required placeholder="Person ID" disabled><br></td></tr>
      </table>
      User's role is:<br>
      
      <script>
	function changeRole(){
		document.getElementById("newrole").value = document.getElementById("orole").value;
	}
	

      </script>
	<select id="orole" name="orole" form="modform" onchange="changeRole()">
 	<option value="<%= role%>">Keep Previous Role</option>
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
