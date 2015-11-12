
// JavaScript Document
function removeUser(){
	
}
function modifyUser(){
    
    var usr = document.querySelector('input[name="userToMod"]:checked').value;
            
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



