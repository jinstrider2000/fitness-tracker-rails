function showNext(event) {
  event.preventDefault();
}

function showPrevious(event) {
  event.preventDefault();
}

function loadAchievement(response) {
  console.log(response);
}

function displayAchievement(response) {
  console.log(response);
}

function updateLinksData() {
  const nextLink = $("#next");
  const prevLink = $("#prev");
  $.get(`/${nextLink.data("locale")}/users/${nextLink.data("slug")}/achievements/${current_id}/next-id`).done( id => {
    if (id === null) {
      nextLink.css("display", "none");
    }
    nextLink.attr("data-id", id);
  });
  $.get(`/${prevLink.data("locale")}/users/${prevLink.data("slug")}/achievements/${current_id}/previous-id`).done( id => {
    if (id === null) {
      prevLink.css("display", "none");
    }
    prevLink.attr("data-id", id);
  });
}