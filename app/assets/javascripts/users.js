function setCurrentUser() {
  if (!window.currentUser) {
    $.get("/current-user", user => window.currentUser = user);
  }
}

function userIndexInit() {
  handlebarsUserIndexInit();
  displayUserIndex();
}

function handlebarsUserIndexInit() {
  if (!window.indexTemplate) {
    window.indexTemplate = Handlebars.compile($("#index-template").html());
  }
  if (!window.userIndexPartial) {
    window.userIndexPartial = Handlebars.compile($("#user-index-partial").html());
  }
  if (!Handlebars.partials.userIndex) {
    Handlebars.registerPartial("userIndex", $("#user-index-partial").html());
  }
  if (!Handlebars.partials.actionButton) {
    Handlebars.registerPartial("actionButton", $("#user-action-button-partial").html()); 
  }
}

function displayUserIndex() {
  $.get(`${window.location.pathname}.json`, function (users) {
    const indexDiv = $("#user-index-items");
    indexDiv.html(window.indexTemplate(users));
  });
}

function primaryActionButton(button) {
  
}

function secondaryActionButton(button) {
  
}