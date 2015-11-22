function loginInfo(){
	document.getElementById("message").innerHTML = "Logged in as '" + getUser() + "' with " + expandPermissions(getRole()) + " privilege<br><br>" + explainRole(getRole());
}

function expandPermissions(v){
	if(v == "a"){return "Administrator"}
	else if(v == "s"){return "Scientist"}
	else if(v == "d"){return "Data Curator"}

}

function explainRole(r){
	if(r == "a"){return "As an Administrator, you may create, view, remove and edit the information of all users and sensors"}
	else if(r == "s"){return "As a Scientist, you may subscribe to sensors, search tyheir data and view an analysis of their data"}
	else if(r == "d"){return "As a Data Curator, you may upload new data"}
}
