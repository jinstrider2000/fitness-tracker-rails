function getLocale() {
  return $("body").attr("lang");
}

function setLocale() {
  I18n.locale = getLocale();
}