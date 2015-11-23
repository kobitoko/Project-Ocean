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
    <b>Add User record to existing Person record:</b><br>
    <p id="grabPerson"></p>
 <%
Boolean debug = Boolean.TRUE;

//gra cookies
Integer pid = null;
//Based on tutorials at http://www.tutorialspoint.com/
Cookie cookie = null;
Cookie[] cookies = null;
String comppid = "modpid";
cookies = request.getCookies();
   if( cookies != null ){
	 for (Integer i = 0; i < cookies.length; i++){
         	cookie = cookies[i];
		
		if(cookie.getName().equals(comppid)){
			
			pid = Integer.parseInt(cookie.getValue());
		}
}
}
%>

    <form action="assocAccount.jsp" name="modform" method="post">
      <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <table style="width:100%;border-style:inset";>
      <tr><td><p style="display:inline">Username: </p></td><td><input type="text" id="moduid" value ="" name="uid" maxlength="32" required placeholder="Username"><br></td></tr>
   
	 <tr><td><p style="display:inline">Person ID: </p></td><td><input id="modpid" type="number" value="<%= pid%>" name="pid" min="0" maxlength="38" required placeholder="Password ID" disabled><br></td></tr>
<tr><td><p style="display:inline">New Role: </p></td><td><input id="role" type="text" value="s" name="role" min="1" maxlength="1" required placeholder="Role" disabled><br></td></tr>
      <tr><td><p style="display:inline">Password: </p></td><td><input type="password" name="pass" min="0" maxlength="32" required placeholder="New Password"><br></td></tr>

      </table>
      User's role is:<br>
      
      <script>
	//populate field from drop down
	function changeRole(){
		document.getElementById("role").value = document.getElementById("orole").value;
	}
	
  function releaseLocks(){
    document.getElementById("modpid").disabled = "";
    document.getElementById("role").disabled = "";
  }
	


      </script>
	<select id="orole" name="orole" form="modform" onchange="changeRole()">

	
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
