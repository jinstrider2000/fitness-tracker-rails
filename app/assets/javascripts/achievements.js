function showNext(link) {
  $.get(`/${link.dataset.locale}/users/${link.dataset.slug}/achievements/${link.dataset.id}/next`).done(loadAchievement).always();
}

function showPrevious(link) {
  $.get(`/${link.dataset.locale}/users/${link.dataset.slug}/achievements/${link.dataset.id}/previous`).done(loadAchievement).always();
}

function loadAchievement(response) {
  console.log(response);
}

function toggleLink(response) {
  console.log(response);
}