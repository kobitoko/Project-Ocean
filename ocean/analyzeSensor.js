



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
	}
	if((document.getElementById("month").value == 0)){
		document.getElementById("emptyWK").selected = 'selected';
	}
	if(document.getElementById("week").value == 0){
		document.getElementById("emptyDY").selected = 'selected';
	}
	cascadeLocks();

}

function cascadeLocks(){
	if(document.getElementById("quarter").value != 1){
		document.getElementById("mo1").disabled = "disabled";
		document.getElementById("mo2").disabled = "disabled";
		document.getElementById("mo3").disabled = "disabled";
	} else {
		document.getElementById("mo1").disabled = "";
		document.getElementById("mo2").disabled = "";
		document.getElementById("mo3").disabled = "";
	}
	if(document.getElementById("quarter").value != 2){
		document.getElementById("mo4").disabled = "disabled";
		document.getElementById("mo5").disabled = "disabled";
		document.getElementById("mo6").disabled = "disabled";
	} else {
		document.getElementById("mo4").disabled = "";
		document.getElementById("mo5").disabled = "";
		document.getElementById("mo6").disabled = "";
	}
	if(document.getElementById("quarter").value != 3){
		document.getElementById("mo7").disabled = "disabled";
		document.getElementById("mo8").disabled = "disabled";
		document.getElementById("mo9").disabled = "disabled";
	} else {
		document.getElementById("mo7").disabled = "";
		document.getElementById("mo8").disabled = "";
		document.getElementById("mo9").disabled = "";
	}
	if(document.getElementById("quarter").value != 4){
		document.getElementById("mo10").disabled = "disabled";
		document.getElementById("mo11").disabled = "disabled";
		document.getElementById("mo12").disabled = "disabled";
	} else {
		document.getElementById("mo10").disabled = "";
		document.getElementById("mo11").disabled = "";
		document.getElementById("mo12").disabled = "";
	}
	
}



