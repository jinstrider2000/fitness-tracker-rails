class NewsFeedItem {
  constructor(init) {
    Object.assign(this, init);
    window.feedItemDates[this.id] = new Date(this.created_at);
  }

  static sinceCreated(timeCreated) {
    const timeDifferenceSeconds = (window.lastTimeFeedUpdated - timeCreated)/1000;
    if (timeDifferenceSeconds >= 0 && timeDifferenceSeconds <= 5) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.now")
    } else if(timeDifferenceSeconds >= 6 && timeDifferenceSeconds <= 59) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.sec", {count: timeDifferenceSeconds})
    } else if(timeDifferenceSeconds >= 60 && timeDifferenceSeconds <= 3599) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.min", {count: timeDifferenceSeconds/60})
    } else if(timeDifferenceSeconds >= 3600 && timeDifferenceSeconds <= 86399) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.hour", {count: timeDifferenceSeconds/3600})
    } else if(timeDifferenceSeconds >= 86400 && timeDifferenceSeconds <= 2627999) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.day", {count: timeDifferenceSeconds/86400})
    } else if(timeDifferenceSeconds >= 2628000 && timeDifferenceSeconds <= 31535999) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.month", {count: timeDifferenceSeconds/2628000})
    } else {
      return I18n.t("news_feed.news_feed_helper.time_since_created.year", {count: timeDifferenceSeconds/31536000})
    }
  }

  get timeSinceCreated() {
    return sinceCreated(window.feedItemDates[this.id]);
  }
}

function newsFeedUpdateInit() {
  if (!window.newsFeedItemTemplate) {
    window.newsFeedItemTemplate = Handlebars.compile($("#news-feed-item-template").html());
  }
  if (!window.lastFeedItemID) {
    window.lastFeedItemID = $("#news-feed-items-container > div.news-feed-item:first-child").attr("id");
  }
  if (!window.numOfFeedItemsPending) {
    window.numOfFeedItemsPending = 0;
  }
  if (!window.feedItemDates) {
    window.feedItemDates = {};
    for (const feedItem of $(".news-feed-item")) {
      const date = new Date(feedItem.dataset.createdAt);
      window.feedItemDates[feedItem.id] = date;
    }
  }
  if (!window.newFeedUpdateInterval) {
    window.newFeedUpdateInterval = setInterval(updateNewsFeed, 60000);
  }
}

function updateNewsFeed() {
  if (window.location.pathname === "/" || window.location.pathname === `/${I18n.locale}/news-feed`) {
    window.lastTimeFeedUpdated = new Date(Date.now());
    $.get(`/${I18n.locale}/news-feed.json?latest_id=${window.lastFeedItemID}`, function (newsFeedItems, status, responseObj) {
      console.log(this);
    }).fail(ajaxErrorMessage);
  } else {
    clearInterval(window.newFeedUpdateInterval);
    window.newFeedUpdateInterval = null;
    window.numOfFeedItemsPending = null;
    window.lastFeedItemID = null;
    window.feedItemDates = null;
  }
}