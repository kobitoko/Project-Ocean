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

Integer pid = null;
String user = null;
String role = null;
//Based on tutorials at http://www.tutorialspoint.com/
Cookie cookie = null;
Cookie[] cookies = null;
String comppid = "modpid";
String compname = "modname";
String comprole = "modrole";
cookies = request.getCookies();
   if( cookies != null ){
	 for (Integer i = 0; i < cookies.length; i++){
         	cookie = cookies[i];
		
		if(cookie.getName().equals(comppid)){pid = Integer.parseInt(cookie.getValue());}
		if(cookie.getName().equals(compname)){user = cookie.getValue();}
		if(cookie.getName().equals(comprole)){role = cookie.getValue();}
}
}
if(role.equals("Scientist")){role = "s";
}else if(role.equals("Administrator")){role = "a";
}else if(role.equals("Data Curator")){role = "d";};
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
     <tr><td> <p style="display:inline">First Name: </p></td><td><input type="text" value="<%= fname%>" name="fname" maxlength="24" required placeholder="First Name"><br></td></tr>
      <tr><td><p style="display:inline">Family Name: </p></td><td><input type="text" value="<%= lname%>" name="lname" maxlength="24" required placeholder="Last Name"><br></td></tr>
      <tr><td><p style="display:inline">Address: </p></td><td><input type="text" name="address" value="<%= add%>" maxlength="128" required placeholder="Address"><br></td></tr>
      <tr><td><p style="display:inline">Email: </p></td><td><input type="text" name="email" maxlength="128" value="<%= email%>" required placeholder="Email"><br></td></tr>
      <tr><td><p style="display:inline">Phone: </p></td><td><input type="text" name="phone" maxlength="10" value="<%= phone%>" required placeholder="Phone"><br></td></tr>
	 <tr><td><p style="display:inline">Person ID: </p></td><td><input id="modpid" type="number" value="<%= pid%>" name="pid" min="0" maxlength="38" required placeholder="Person ID"><br></td></tr>
      <tr><td><p style="display:inline">Password: </p></td><td><input type="password" name="pass" min="0" maxlength="32" placeholder="New Password"><br></td></tr>
<tr><td><p style="display:inline">New Role: </p></td><td><input id="newrole" type="text" value="<%= role%>" name="newrole" min="0" maxlength="1" required placeholder="Person ID" disabled><br></td></tr>
      </table>
      User's role is:<br>
      
      <script>
	function changeRole(){
		document.getElementById("newrole").value = document.getElementById("orole").value;
	}
	
  function releaseLocks(){
    document.getElementById("newrole").disabled = "";
  }

      </script>
	<select id="orole" name="orole" form="modform" onchange="changeRole()">
 	<option value="<%= role%>">Keep Previous Role</option>
	
      <option value="s">Scientist</option>
      <option value="d">Data Curator</option>
      <option value="a">Administrator</option>
      <select> 
      <button onClick="releaseLocks()" value="Update">Update</button>
    </form>
    </div>
</div>
</div>
</body>
