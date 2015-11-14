
// JavaScript Document
function removeUser(){
	
}
function modifyUser(){
    
    var usr = document.querySelector('input[name="userToMod"]:checked').value;
    var values = new Array;
    values = usr.split(";;");
   document.cookie = 'modname="' + values[0] + '";';document.cookie = 'modpid="' + values[1] + '";';document.cookie = 'modrole="' + values[2] + '";';
window.setTimeout('window.location="modiUser.jsp"; ',50);
}



