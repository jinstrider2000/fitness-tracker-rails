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
      window.newsFeedLastUpdate = new Date(Date.now());
      console.log(window.newsFeedLastUpdate.toISOString());
    }, 5000)
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