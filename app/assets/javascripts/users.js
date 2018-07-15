function setCurrentUser() {
  if (!window.currentUser) {
    $.get("/current-user", user => window.currentUser = user);
  }
}

function userIndexInit() {
  setCurrentUser();
  handlebarsUserIndexInit();
  updateUserIndex();
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
  if (!Handlebars.helpers.ownProfile) {
    Handlebars.registerHelper("ownProfile", function () {
      return window.currentUser.slug === this.slug
    });
  }
}

function updateUserIndex() {
  setTimeout(() => {
    $.get(`${window.location.pathname}.json`, function (users) {
      const indexDiv = $("#user-index-items");
      if (users.hasOwnProperty("message")) {
        indexDiv.html($('<p class="text-center no-items-style"></p>').html(users.message));
      } else {
        indexDiv.html(window.indexTemplate(users));
      }
    });
  }, 250);
}

function actionButton(button) {
  const btn = $(button);
  let refresh = false;
  const slugPattern = new RegExp(window.currentUser.slug);
  const myPathMatch = window.location.pathname.match(slugPattern)
  const pathActionMatch = window.location.pathname.match(/\/(following|followers|blocked|muted)$/);
  if (!!myPathMatch && ((pathActionMatch[1] === "following" && ((btn.data("useraction") === "unfollow") || (btn.data("useraction") === "block"))|| (pathActionMatch[1] === "followers" && btn.data("useraction") === "block") || (pathActionMatch[1] === "blocked" && btn.data("useraction") === "unblock")||(pathActionMatch[1] === "muted" && btn.data("useraction") === "unmute")))) {
    refresh = true;
  }
  $.ajax({
    method: btn.data("submitmethod"),
    url: `/${getLocale()}/users/${btn.data("slug")}/${btn.data("useraction")}.json`,
    success: ajaxNoticeMessage,
    error: ajaxErrorMessage
  }).done(function (response) {
    if (refresh) {
      updateUserIndex();
    } else {
      updateUserPartial(response);
    }
  });
}

function updateUserPartial(response) {
  const userDiv = $(`#${response.id}`);
  $.get(`/${getLocale()}/users/${response.slug}.json?return_type=index`, function (user) {
    userDiv.html(window.userIndexPartial(user));
  });
}