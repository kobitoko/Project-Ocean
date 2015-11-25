
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
<p>
- To add a new Person record and User record, use the form on the left<br>
- To add a new User record to an existing Person record, check the radio button in that row under "Add Associated User",and press the "Add Associated User" button.<br>
- To remove a user, check the radio button in that row under "Remove User",and press the "Remove User" button.<br>
- To modify an existing user, check the radio button in that row under "Modify User",and press the "Modify User" button.
</p>
 <div class="inline" style="border-style:inset;width:20%;;">
    <form action="createAccount.jsp" method="post"name="addform" id="addform">
      <b>Create New User & Person:</b><br>
       <!-- using placeholder assumes HTML5 support. Just use emtpy value or nothing if we cant use html5.-->
      <table style="width:100%;border-style:inset";>
      <tr><td ><p style="display:inline">Username: </p></td><td><input type="text" id="uid" name="uid" maxlength="32" required placeholder="Username"><br></td></tr>
     <tr><td> <p style="display:inline">First Name: </p></td><td><input type="text" name="fname" maxlength="24" required placeholder="First Name"><br></td></tr>
      <tr><td><p style="display:inline">Family Name: </p></td><td><input type="text" name="lname" maxlength="24" required placeholder="Last Name"><br></td></tr>
      <tr><td><p style="display:inline">Address: </p></td><td><input type="text" name="address" maxlength="128" required placeholder="Address"><br></td></tr>
      <tr><td><p style="display:inline">Email: </p></td><td><input type="text" name="email" maxlength="128" required placeholder="Email"><br></td></tr>
      <%
      Boolean debug = Boolean.FALSE;
      
      
      String mUrl = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String mDriverName = "oracle.jdbc.driver.OracleDriver";
      
      String mUser = "TRY HARDER";
      String mPass = "TRY HARDER";
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
		String getMaxPID = "select MAX(PERSON_ID) from PERSONS";
		mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          	stmnt = mCon.createStatement();
          //calcualtes the max PID and uses this as the default value when creating new users
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


	%>
      <tr><td><p style="display:inline">Phone: </p></td><td><input type="text" name="phone" maxlength="10" required placeholder="Phone"><br></td></tr>
      <tr><td><p style="display:inline">Person ID: </p></td><td><input id="pid" type="number" value="<%= maxpid %>" name="pid" min="0" maxlength="38" required placeholder="Person ID"><br></td></tr>
      <tr><td><p style="display:inline">Password: </p></td><td><input type="password" name="pass" min="0" maxlength="32" required placeholder="New Password"><br></td></tr>
      </table>
  User's role is:<br>
      <select id="role" name="role" form="addform">
      <option value="s">Scientist</option>
      <option value="d">Data Curator</option>
      <option value="a">Administrator</option>
      <select>
      <input type="submit" name="submit" value="Create!">
    </form>
    </div>
    <div class="inline" style="border-style:inset;width:75%;">
   

    <table style="width:100%;border-style:inset";>
    <tr>
    <col>
<col>
<col>
<col width="90px">
<col width="150px">
<col width="75px">

    <th>Username</th>
    <th>PERSON ID</th>
    <th>Role</th>
    <th ><button onClick="modifyUser()"style="background-color:green;color:white;display:inline;"  value="Modify Checked User">Modify User</button></th>
<th><button onClick="assocUser()"style="background-color:yellow;color:black;display:inline;"  value="Add Associated User">Add Associated User</button></th>
    <form action="removeThatAccount.jsp" method="post">   
    <th><input style="background-color:blue;color:white;display:inline;" type="submit" name="submit" value="Remove User"></th>
 
    </tr>
    <tr>
       <%
      String queryUsers = "select USER_NAME, ROLE, PERSON_ID from USERS order by PERSON_ID, USER_NAME, ROLE";
      // actually log in and perform statements
      try {
          mCon = DriverManager.getConnection(mUrl, mUser, mPass);
          stmnt = mCon.createStatement();
          
          ResultSet rset = stmnt.executeQuery(queryUsers);
          
          while(rset.next()) {
            String usr = rset.getString(1);
            String grole = rset.getString(2);
            Integer pid = new Integer(rset.getInt(3));
     
	//expands role name
            if(grole == null){grole="";};
            if(grole.equals("a")) {
              grole = "Administrator";
            } else if (grole.equals("s")) {
              grole = "Scientist";
            } else if (grole.equals("d")) {
              grole = "Data Curator";
            }
            
            String open = "<td>";
            String close = "</td>";
	    String tropen = "<tr>";
	    String trclose = "</tr>";	
			//defines button structure
			String buttonmod = "<input type='radio' id='userToMod' name='userToMod' value='" + usr + ";;" + pid.toString() + ";;" + grole +  "' checked>";
			
		
			String buttonrm = "<input type='radio' name='userToDelete' value='" + usr + "' checked>";

			String buttonassoc = "<input type='radio' name='userToAssoc' value='" + pid.toString() + "' checked>";
			
            out.println( tropen + open + usr + close + open + pid.toString() + close + open + grole + close + open + buttonmod +  close + open + buttonassoc + close + open + buttonrm + close + trclose);
            
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
    
     

	</div>

    


</div>
    </form>
</div>
    </div>
    </div>
  </body>
</html>

