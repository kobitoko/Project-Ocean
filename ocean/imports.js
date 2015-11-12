// JavaScript Document


window.onload = function(){
	role = getRole();
	
	updateNav(role);
	
}

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

function getUser(){
	var cooks = document.cookie.split(';');
	for(i=0;i<cooks.length;i++){
		var temp = cooks[i].split("=");
		if(temp[0].replace(" ","") == "name"){return temp[1];}
		else {};
	}
}

function getPID(){
	var cooks = document.cookie.split(';');
	for(i=0;i<cooks.length;i++){
		var temp = cooks[i].split("=");
		if(temp[0].replace(" ","") == "pid"){return temp[1];}
		else {};
	}
}

function updateNav(r){
	role = r;
	document.getElementById("header").innerHTML = '<button id="home" class="home";>HOME</button><button id="logout" class="logout">LOGOUT</button><button id="account" class="logout">MY INFO</button><button id="senman" class="sysadmin">SENSOR MANAGEMENT</button><button id="usrman" class="sysadmin">USER MANAGEMENT</button><button id="upload" class="curator">UPLOAD DATA</button><button id="search" class="navi">SEARCH SENSORS</button><button id="subscribe" class="navi">SENSOR SUBSCRIPTIONS</button><button id="analyze" class="navi">ANALYZE DATA</button>';

document.getElementById("home").onclick = function(){window.location.href="landing.html";}
document.getElementById("logout").onclick = function(){document.cookie = "name=;";document.cookie = "role=;"; window.location.href="login.html";}
document.getElementById("senman").onclick = function(){window.location.href="sensormanage.jsp";}
document.getElementById("usrman").onclick = function(){window.location.href="usermanage.jsp";}
document.getElementById("upload").onclick = function(){window.location.href="upload.html";}
document.getElementById("search").onclick = function(){window.location.href="search.jsp";}
document.getElementById("subscribe").onclick = function(){window.location.href="subscribe.jsp";}
document.getElementById("analyze").onclick = function(){window.location.href="analyze.html";}
document.getElementById("account").onclick = function(){window.location.href="mymanage.jsp";}




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
} else {
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("upload").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
	document.getElementById("home").style.display = 'none';
	document.getElementById("account").style.display = 'none';
	document.getElementById("content").innerHTML = "<br>You are not logged in. Please <a href=login.html>Login</a>";
}
checkPermissions(role);
}

function changeRole(newRole){
	updateNav(newRole);
} 



function checkPermissions(r){
	if(((permission == 'scientist') && (r != "s")) || ((permission == 'admin') && (r != "a")) || ((permission == 'curator') && (r != "d"))){
		document.getElementById("content").innerHTML = "<br>You do not have permission to access this page. If you believe this is a mistake, please contact your System Administrator";	
	}
	
}
	
