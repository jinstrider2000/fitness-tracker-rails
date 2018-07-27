class NewsFeedItem {
  constructor(init) {
    Object.assign(this, init);
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
        $.get(`/${I18n.locale}/news-feed.json?latest_created_at=${encodeURI(window.lastFeedItemCreated)}`, function (newsFeedItems, status, responseObj) {
          // console.log(newsFeedItems);
        });
      } else {
        clearInterval(window.newFeedUpdateInterval);
        window.newFeedUpdateInterval = null;
      }
    }, 30000)
  }
  handlebarsNewsFeedIndexInit();
}

function handlebarsNewsFeedIndexInit() {
  if (!window.newsFeedItemTemplate) {
    window.newsFeedItemTemplate = Handlebars.compile($("#news-feed-item-template").html());
  }
}

function tester(params) {
  
}

function seconds_since_epoch() {
  return Math.floor(Date.now()/1000)
}