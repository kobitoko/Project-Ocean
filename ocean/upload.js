//This function makes the data fields in the Images table required when it detects that a jpg is being uploaded
function verifyLockJPG(){

		document.getElementById("jpgsensorid").required = true;
		document.getElementById("jpgtimecreated").required = true;
		document.getElementById("jpgdatecreated").required = true;
		document.getElementById("jpgdescription").required = true;
	
}

//This function makes the data fields in the Audio_recordings table required when it detects that a wav is being uploaded
function verifyLockWAV(){

		document.getElementById("wavsensorid").required = true;
		document.getElementById("wavtimecreated").required = true;
		document.getElementById("wavdatecreated").required = true;
		document.getElementById("wavdescription").required = true;
		document.getElementById("wavlength").required = true;
	

}
