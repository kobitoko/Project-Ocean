// JavaScript Document
function removeUser(){
	
}
function modifyUser(){
    
    var usr = document.querySelector('input[name="userToMod"]:checked').value;
    document.getElementById("grabPerson").innerHTML = '<%try{' + queryUsers + 'mCon = DriverManager.getConnection(mUrl, mUser, mPass);stmnt = mCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);ResultSet rset = stmnt.executeQuery(queryUsers);if(rset.next()){String fname = rest.getString(1);String lname = rest.getString(2);String add = rest.getString(3);String email = rest.getString(4);String phone = rest.getString(5);} else {out.println("Something went wrong.");}} catch(SQLException ex) {if (debug)out.println("<BR>-debugLog:Received a SQLException: " + ex.getMessage());System.err.println("SQLException: " + ex.getMessage());}'
            String queryUsers = "select FIRST_NAME, LAST_NAME, ADDRESS, EMAIL, PHONE from PERSONS where PERSON_ID='" + usr + "';";
            // Remove first those who depend on the foreign primary key USER_NAME.
            
           

          
          
          
          
          
       
    var values = new Array;
    values = usr.split(";;");
    document.getElementById("moduid").value = values[0];
    document.getElementById("modpid").value = values[1];
    if(values[2] == "Scientist"){
	document.getElementById("modrole").value = "s";	
    } else if(values[2] == "Administrator"){
        document.getElementById("modrole").value = "a";
    } else if(values[2] == "Data Curator"){
        document.getElementById("modrole").value = "d";
    }
}
