



function olapSensor(){
    
    var usr = document.querySelector('input[name="subToAnal"]:checked').value;
  
document.cookie = 'modsid="' + usr + '";';
writeOLAPcookies();
window.setTimeout('window.location="analyzeSensor.jsp"; ',50);
}

function updateOLAPcookies(){
document.cookie = 'olapYR="' + document.getElementById("year").value + '";';
document.cookie = 'olapQU="' + document.getElementById("quarter").value + '";';;
document.cookie = 'olapMO="' + document.getElementById("month").value + '";';;
document.cookie = 'olapWK="' + document.getElementById("week").value + '";';; 
document.cookie = 'olapDY="' + document.getElementById("day").value + '";';;
window.setTimeout('window.location="analyzeSensor.jsp"; ',50);
}

function writeOLAPcookies(){
document.cookie = 'olapYR="0"';
document.cookie = 'olapQU="0"';
document.cookie = 'olapMO="0"';
document.cookie = 'olapWK="0"';
document.cookie = 'olapDY="0"';
}

function updateRollup(){
 	if(document.getElementById("year").value == 0){
		document.getElementById("emptyQU").selected = 'selected';
	}
	if(document.getElementById("quarter").value == 0){
		document.getElementById("emptyMO").selected = 'selected';
		document.getElementById("emptyWK").selected = 'selected';
	}
	if((document.getElementById("month").value == 0) && (document.getElementById("week").value == 0)){
		document.getElementById("emptyDY").selected = 'selected';
	}
	if(document.getElementById("month").value != 0){
		document.getElementById("emptyWK").selected = 'selected';
	}
}

function updateRollupWK(){
 	if(document.getElementById("year").value == 0){
		document.getElementById("emptyQU").selected = 'selected';
	}
	if(document.getElementById("quarter").value == 0){
		document.getElementById("emptyMO").selected = 'selected';
		document.getElementById("emptyWK").selected = 'selected';
	}
	if((document.getElementById("month").value == 0) && (document.getElementById("week").value == 0)){
		document.getElementById("emptyDY").selected = 'selected';
	}
	if(document.getElementById("week").value != 0){
		document.getElementById("emptyMO").selected = 'selected';
	}
}



