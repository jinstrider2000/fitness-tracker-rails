class NewsFeedItem {
  constructor(init) {
    Object.assign(this, init);
    this.date = new Date(this.created_at);
  }

  static sinceCreated(dateTime) {

  }

  get timeSinceCreated() {
    return "Hey!"
  }
}

function newsFeedUpdateInit() {
  if (!window.lastFeedItemID) {
    window.lastFeedItemID = $("#news-feed-items-container > div.news-feed-item:first-child").attr("id");
  }
  if (!window.newFeedUpdateInterval) {
    window.newFeedUpdateInterval = setInterval(updateNewsFeed, 60000);
  }
  if (!window.numOfFeedItemsPending) {
    window.numOfFeedItemsPending = 0;
  }
  handlebarsNewsFeedIndexInit();
}

function updateNewsFeed() {
  if (window.location.pathname === "/" || window.location.pathname === `/${I18n.locale}/news-feed`) {
    window.lastTimeFeedUpdated = new Date(Date.now());
    $.get(`/${I18n.locale}/news-feed.json?latest_id=${window.lastFeedItemID}`, function (newsFeedItems, status, responseObj) {
      console.log(newsFeedItems);
    }).fail(ajaxErrorMessage);
  } else {
    clearInterval(window.newFeedUpdateInterval);
    window.newFeedUpdateInterval = null;
    window.numOfFeedItemsPending = null;
    window.lastFeedItemID = null;
  }
}

function handlebarsNewsFeedIndexInit() {
  if (!window.newsFeedItemTemplate) {
    window.newsFeedItemTemplate = Handlebars.compile($("#news-feed-item-template").html());
  }
}