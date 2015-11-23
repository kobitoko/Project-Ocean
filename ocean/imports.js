// JavaScript Document

//On document load, grab the role
window.onload = function(){
	role = getRole();	
	updateNav(role);	
}

//Based on tutorials at http://www.tutorialspoint.com/
//Grabs the role from cookies
function getRole(){
	var cooks = document.cookie.split(';');
	
	for(i=0;i<cooks.length;i++){
		var temp = cooks[i].split("=");
		
		if(temp[0].replace(" ","") == "role"){
			
			return temp[1];
		}
		else {};
	}
}

//Based on tutorials at http://www.tutorialspoint.com/
//Grabs the user from cookies
function getUser(){
	var cooks = document.cookie.split(';');
	for(i=0;i<cooks.length;i++){
		var temp = cooks[i].split("=");
		if(temp[0].replace(" ","") == "name"){return temp[1];}
		else {};
	}
}

//Based on tutorials at http://www.tutorialspoint.com/
//Grabs the PID from cookies
function getPID(){
	var cooks = document.cookie.split(';');
	for(i=0;i<cooks.length;i++){
		var temp = cooks[i].split("=");
		if(temp[0].replace(" ","") == "pid"){return temp[1];}
		else {};
	}
}

//builds the navigation
function updateNav(r){
	role = r;
	//generates the top menu bar
	document.getElementById("header").innerHTML = '<button id="home" class="home";>HOME</button><button id="logout" class="logout">LOGOUT</button><button name="account" id="account" class="logout">MY INFO</button><button id="help" class="logout";>HELP</button><button id="senman" class="sysadmin">SENSOR MANAGEMENT</button><button id="usrman" class="sysadmin">USER MANAGEMENT</button><button id="upload" class="curator">UPLOAD DATA</button><button id="search" class="navi">SEARCH SENSORS</button><button id="subscribe" class="navi">SENSOR SUBSCRIPTIONS</button><button id="analyze" class="navi">ANALYZE DATA</button>';

//assigned the links for each when clicked
document.getElementById("home").onclick = function(){window.location.href="landing.html";}
document.getElementById("logout").onclick = function(){logout();}
document.getElementById("senman").onclick = function(){window.location.href="sensormanage.jsp";}
document.getElementById("usrman").onclick = function(){window.location.href="usermanage.jsp";}
document.getElementById("upload").onclick = function(){window.location.href="upload.html";}
document.getElementById("search").onclick = function(){window.location.href="search.jsp";}
document.getElementById("subscribe").onclick = function(){window.location.href="subscribe.jsp";}
document.getElementById("analyze").onclick = function(){window.location.href="analyze.jsp";}
document.getElementById("account").onclick = function(){window.location.href="mymanage.jsp";}
document.getElementById("help").onclick = function(){window.location.href="help.html";}

//logging out removes all cookies
function logout(){
	document.cookie = "name=;";
	document.cookie = "role=;";
	document.cookie = "pid=;"; 
	document.cookie = "modpid=;"; 
	document.cookie = "modrole=;"; 
	document.cookie = "modname=;"; 
	document.cookie = "olapYR=;";
	document.cookie = "olapQU=;";
	document.cookie = "olapMO=;"; 
	document.cookie = "olapWK=;"; 
	document.cookie = "olapDY=;";
	document.cookie = "modsid=;";
	window.location.href="login.html";
}


//hides navigation items tied to specific permissions
if(role == "a"){
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("upload").style.display = 'none';
}
else if(role == "s"){
	document.getElementById("upload").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
}
else if(role == "d"){
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
//displays for the login page and help page
} else if(permission == 'loggedout'){
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("upload").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
	document.getElementById("home").style.display = 'none';
	document.getElementById("account").style.display = 'none';
	document.getElementById("logout").innerHTML = "LOG IN";
} else {
//view when not logged in
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("upload").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
	document.getElementById("home").style.display = 'none';
	document.getElementById("account").style.display = 'none';
	document.getElementById("logout").innerHTML = "LOG IN";
	document.getElementById("content").innerHTML = "<br>You are not logged in. Please <a href=login.html>Login</a>";
}
checkPermissions(role);
}

//update nav when permissions change
function changeRole(newRole){
	updateNav(newRole);
} 


//checks permissions and wipes content if the user does not meet the permission
function checkPermissions(r){
	if(((permission == 'scientist') && (r != "s")) || ((permission == 'admin') && (r != "a")) || ((permission == 'curator') && (r != "d"))){
		document.getElementById("content").innerHTML = "<br>You do not have permission to access this page. If you believe this is a mistake, please contact your System Administrator";	
	}
	
}
	
