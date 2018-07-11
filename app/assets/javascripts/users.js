function setCurrentUser() {
  $.get("/current-user", user => window.currentUser = user );
}

function getUserIndex() {
  $.get(`${window.location.pathname}.json`, function (users) {
    
  });
}

function userIndexInit() {
  
}