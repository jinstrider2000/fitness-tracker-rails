function flashToggle() {
  setTimeout(() => {
    $("#notice-flash-msg").html("");
    $("#alert-flash-msg").html("");
    $("#error-flash-msg").html("");
  }, 3000);
}

function ajaxErrorMessage(response) {
  const msg = $("#error-flash-msg");
  msg.html(response.responseJSON.error_message);
  setTimeout(() => {
    msg.html("");
  }, 3000);
}

function ajaxNoticeMessage(response) {
  const msg = $("#notice-flash-msg");
  msg.html(response.message);
  setTimeout(() => {
    msg.html("");
  }, 3000);
}