// JavaScript Document


window.onload = function(){
	role = permission;
	updateNav(role);
	
}

function updateNav(r){
	role = r;
	document.getElementById("header").innerHTML = '<button id="home" class="home";>HOME</button><button id="logout" class="logout">LOGOUT</button><button id="senman" class="sysadmin">SENSOR MANAGEMENT</button><button id="usrman" class="sysadmin">USER MANAGEMENT</button><button id="upload" class="curator">UPLOAD DATA</button><button id="search" class="navi">SEARCH SENSORS</button><button id="subscribe" class="navi">SENSOR SUBSCRIPTIONS</button><button id="analyze" class="navi">ANALYZE DATA</button><button id="testcur" class="test">TEST: CURATOR</button><button class="test" id="testsci">TEST: SCIENTIST</button><button id="testadmin" class="test">TEST: ADMIN</button>';

document.getElementById("home").onclick = function(){window.location.href="landing.html";}
document.getElementById("logout").onclick = function(){window.location.href="login.html";}
document.getElementById("senman").onclick = function(){window.location.href="sensormanage.jsp";}
document.getElementById("usrman").onclick = function(){window.location.href="usermanage.jsp";}
document.getElementById("upload").onclick = function(){window.location.href="upload.html";}
document.getElementById("search").onclick = function(){window.location.href="search.jsp";}
document.getElementById("subscribe").onclick = function(){window.location.href="subscribe.jsp";}
document.getElementById("analyze").onclick = function(){window.location.href="analyze.html";}

document.getElementById("testadmin").onclick = function(){changeRole("admin");}
document.getElementById("testcur").onclick = function(){changeRole("curator");}
document.getElementById("testsci").onclick = function(){changeRole("scientist");}


if(role == "admin"){
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("upload").style.display = 'none';
}
if(role == "scientist"){
	document.getElementById("upload").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
}
if(role == "curator"){
	document.getElementById("search").style.display = 'none';
	document.getElementById("analyze").style.display = 'none';
	document.getElementById("subscribe").style.display = 'none';
	document.getElementById("usrman").style.display = 'none';
	document.getElementById("senman").style.display = 'none';
}
checkPermissions(role);
}

function changeRole(newRole){
	updateNav(newRole);
}

function checkPermissions(r){
	if(((permission == 'scientist') && (r != "scientist")) || ((permission == 'admin') && (r != "admin")) || ((permission == 'curator') && (r != "curator"))){
		document.getElementById("content").innerHTML = "<br>You do not have permission to access this page. If you believe this is a mistake, please contact your System Administrator";	
	}
}
	