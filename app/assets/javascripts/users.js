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
  setTimeout(() => {
    $.get(`${window.location.pathname}.json`, function (users) {
      const indexDiv = $("#user-index-items");
      if (users.hasOwnProperty("message")) {
        indexDiv.html($('<p class="text-center no-items-style"></p>').html(users.message));
      } else {
        indexDiv.html(window.indexTemplate(users));
      }
    });
  }, 500);
}

function actionButton(button) {
  const btn = $(button);
  $.ajax({
    method: btn.data("submitmethod"),
    url: `/${getLocale()}/users/${btn.data("slug")}/${btn.data("useraction")}.json`,
    success: ajaxNoticeMessage,
    error: ajaxErrorMessage
  }).done(updateUserIndex);
}

function updateUserIndex(response) {
  const userDiv = $(`#${response.id}`);
  $.get(`/${getLocale()}/users/${response.slug}.json?return_type=index`, function (user) {
    userDiv.html(window.userIndexPartial(user));
  });
}