function flashToggle() {
  setTimeout(() => {
    $("#notice-flash-msg").html("");
    $("#alert-flash-msg").html("");
    $("#error-flash-msg").html("");
  }, 3000);
}