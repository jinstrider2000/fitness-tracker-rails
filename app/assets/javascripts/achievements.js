function showNext(event) {
  event.preventDefault();
  const nextLink = $(this);
  $.get(`/${nextLink.data("locale")}/achievements/${nextLink.data("id")}.json`, displayAchievement).done(achievement => updateLinksData("next", achievement.id));
}

function showPrevious(event) {
  event.preventDefault();
  const prevLink = $(this);
  $.get(`/${prevLink.data("locale")}/achievements/${prevLink.data("id")}.json`, displayAchievement).done(achievement => updateLinksData("prev", achievement.id));
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
    $.get(`/${nextLink.data("locale")}/users/${nextLink.data("slug")}/achievements/${currentId}/next-id`, id => {
      if (id === null) {
        nextLink.css("display", "none");
      }
      nextLink.data("id", id);
      nextLink.data("current", currentId);
    });
  } else {
    nextLink.data("id", prevLink.data("current"));
    nextLink.data("current", currentId);
    if (nextLink.css("display") === "none") {
      nextLink.css("display", "inline");
    }
    $.get(`/${prevLink.data("locale")}/users/${prevLink.data("slug")}/achievements/${currentId}/previous-id`, id => {
      if (id === null) {
        prevLink.css("display", "none");
      }
      prevLink.data("id", id);
      prevLink.data("current", currentId);
    });
  }
}

function initializeLinks() {
  const nextLink = $("#next");
  const prevLink = $("#prev");
  
  if (nextLink.data("id") !== undefined) {
    nextLink.css("display", "inline");
  }
  if (prevLink.data("id") !== undefined) {
    prevLink.css("display", "inline");
  }
}