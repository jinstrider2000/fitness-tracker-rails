function showNext(link) {
  $.get(`/achievements/${link.datalist.ach_id}/next`).done().always();
}

function showPrevious(link) {
  $.get(`/achievements/${link.datalist.ach_id}/prev`).done().always();
}

function loadAchievement(response) {
  $.get()
}

function toggleLink(response) {
  
}