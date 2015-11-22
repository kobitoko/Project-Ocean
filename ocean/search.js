function verifyTime(){
	if(document.getElementById("stype").innerHTML == ""){
		document.getElementById("dateSince").required = true;
		document.getElementById("dateUntil").required = true;
	} else {
		document.getElementById("dateSince").required = false;
		document.getElementById("dateUntil").required = false;
	}
}
