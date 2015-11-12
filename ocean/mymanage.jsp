<!doctype html>
<%@ page import="java.util.*, java.sql.*, org.jasypt.digest.StandardStringDigester"%>
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

Integer pid = Integer.parseInt(request.getParameter("mypid"));
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
      <input type="submit" name="submit" value="Update">
    </form>
 </div>
 </div>
</body>
</html>
<script>
	document.getElementById("fname").value = getPID();
</script>
