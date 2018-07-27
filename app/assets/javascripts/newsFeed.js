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
  if (!window.lastFeedItemCreated) {
    window.lastFeedItemCreated = $("#news-feed-items-container > div:first-child").data("created-at");
  }
  if (!window.newFeedUpdateInterval) {
    window.newFeedUpdateInterval = setInterval(function () {
      if (window.location.pathname === "/" || window.location.pathname === `/${I18n.locale}/news-feed`) {
        window.lastTimeFeedUpdated = new Date(Date.now());
        $.get(`/${I18n.locale}/news-feed.json?latest_created_at=${encodeURI(window.lastFeedItemCreated)}`, function (newsFeedItems, status, responseObj) {
          console.log(newsFeedItems);
        });
      } else {
        clearInterval(window.newFeedUpdateInterval);
        window.newFeedUpdateInterval = null;
      }
    }, 60000);
  }
  handlebarsNewsFeedIndexInit();
}

function handlebarsNewsFeedIndexInit() {
  if (!window.newsFeedItemTemplate) {
    window.newsFeedItemTemplate = Handlebars.compile($("#news-feed-item-template").html());
  }
}