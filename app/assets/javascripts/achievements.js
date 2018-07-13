function achievementShowInit() {
  initializeShowLinks();
  setShowListeners();
  setCurrentUser();
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