function achievementShowInit() {
  initializeShowLinks();
  setShowListeners();
  setCurrentUser();
}

function submitAchievementForm(frm) {
  const form = $(frm);
  const submitBtn = $('#achievement-form input[type="submit"]');
  submitBtn.attr("disabled", true);
  $.ajax({
    method: form.attr("method"),
    url: form.attr("action"),
    data: form.serialize(),
    success: function (response, textStatus, responseObject) {
      if (!!responseObject.getResponseHeader("content-type").match(/json/)) {
        steadyAjaxNoticeMessage(response);
        clearForm();
        submitBtn.attr("disabled", false);
      } else {
        $("#achievement-form").html(response);
      }
    }
  });
}

function setActivityFields(radio) {
  const radioBtn = $(radio);
  const slug = window.location.pathname.match(/\/users\/([A-Za-z0-9_\-]+)\//)
  $.get(`/${getLocale()}/users/${slug[1]}/achievements/${radioBtn.attr('value').toLowerCase()}/new-form-fields`, function (response) {
    $("#achievement-form").html(response);
  }).fail(ajaxErrorMessage);
}

function clearForm() {
  const currentForm = window.location.pathname.match(/new|edit/)
  if (currentForm && currentForm[0] === "new") {
    for (const textInput of $('#achievement-form input[type="text"]')) {
      textInput.value = "";
    }
    for (const textAreaInput of $('#achievement-form textarea')) {
      textAreaInput.value = "";
    } 
  }
  $("#error_explanation").remove()
  for (const errorDiv of $(".field_with_errors")) {
    const parent = $(errorDiv);
    const child = $(errorDiv.innerHTML);
    const currentValue = errorDiv.children[0].value;
    if (currentForm === "new" && currentValue !== undefined) {
      currentValue = "";
    }
    if (currentValue !== undefined) {
      child.attr("value", currentValue);
    }
    parent.replaceWith(child);
  }
}

function setShowListeners() {
  $("#next").on("click", showNext);
  $("#prev").on("click", showPrevious);
}

function getLocale() {
  const locale = window.location.pathname.match(/^\/(\w+)\//) || window.location.search.match(/locale=(\w+)&/)
  return locale[1];
}

function showNext() {
  event.preventDefault();
  const nextLink = $(this);
  $.get(`/${getLocale()}/achievements/${nextLink.data("id")}.json`, displayAchievement).done(achievement => updateLinksData("next", achievement.id)).fail(ajaxErrorMessage);
}

function showPrevious() {
  event.preventDefault();
  const prevLink = $(this);
  $.get(`/${getLocale()}/achievements/${prevLink.data("id")}.json`, displayAchievement).done(achievement => updateLinksData("prev", achievement.id)).fail(ajaxErrorMessage);
}

function displayAchievement(achievement) {
  const heading = $("#ach-show-heading");
  const activityIcon = $("#ach-show-activity-pic");
  const dateCompleted = $("#ach-show-date-completed");
  const activityName = $("#ach-show-name-cals");
  const comment = $("#ach-show-comment");
  const title = $("title");

  heading.html(achievement.view.heading);
  dateCompleted.html(achievement.view.date_completed);
  activityIcon.attr("src",achievement.view.activity_icon_src);
  if (achievement.activity_type === "Food") {
    activityName.html(`${achievement.activity.name} <em>(Cals: +${achievement.activity.calories})</em>`);
  }
  else {
    activityName.html(`${achievement.activity.name} <em>Cals: -${achievement.activity.calories_burned}</em>`);
  }
  comment.html(achievement.comment);
  title.html(achievement.view.title)
}

function updateLinksData(linkName, currentId) {
  const nextLink = $("#next");
  const prevLink = $("#prev");

  if (linkName === "next") {
    prevLink.data("id", nextLink.data("current"));
    prevLink.data("current", currentId);
    if (prevLink.css("display") === "none") {
      prevLink.css("display", "inline");
    }
    $.get(`/${getLocale()}/users/${nextLink.data("slug")}/achievements/${currentId}/next-id`, id => {
      if (id === null) {
        nextLink.css("display", "none");
      }
      nextLink.data("id", id);
      nextLink.data("current", currentId);
      if (window.currentUser.slug === nextLink.data("slug")) {
        $("#ach-show-edit-link").attr("href", `/${getLocale()}/achievements/${currentId}/edit`);
        $("#ach-show-delete-link").attr("href", `/${getLocale()}/achievements/${currentId}`);
      }
    }).fail(ajaxErrorMessage);
  } else {
    nextLink.data("id", prevLink.data("current"));
    nextLink.data("current", currentId);
    if (nextLink.css("display") === "none") {
      nextLink.css("display", "inline");
    }
    $.get(`/${getLocale()}/users/${prevLink.data("slug")}/achievements/${currentId}/previous-id`, id => {
      if (id === null) {
        prevLink.css("display", "none");
      }
      prevLink.data("id", id);
      prevLink.data("current", currentId);
      if (window.currentUser.slug === prevLink.data("slug")) {
        $("#ach-show-edit-link").attr("href", `/${getLocale()}/achievements/${currentId}/edit`);
        $("#ach-show-delete-link").attr("href", `/${getLocale()}/achievements/${currentId}`);
      }
    }).fail(ajaxErrorMessage);
  }
}

function initializeShowLinks() {
  const nextLink = $("#next");
  const prevLink = $("#prev");
  
  if (nextLink.data("id") !== undefined) {
    nextLink.css("display", "inline");
  }
  if (prevLink.data("id") !== undefined) {
    prevLink.css("display", "inline");
  }
}