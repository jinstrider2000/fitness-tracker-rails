function setCurrentUser() {
  $.get("/current-user", user => window.currentUser = user );
}

function userIndexInit() {
  
}