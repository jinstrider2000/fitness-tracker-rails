class NewsFeedItem {
  constructor(init) {
    Object.assign(this, init);
    window.feedItemDates[this.id] = new Date(this.created_at);
  }

  static sinceCreated(timeCreated) {
    const timeDifferenceSeconds = parseInt((window.lastTimeFeedUpdated - timeCreated)/1000);
    if (timeDifferenceSeconds >= 0 && timeDifferenceSeconds <= 5) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.now");
    } else if(timeDifferenceSeconds >= 6 && timeDifferenceSeconds <= 59) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.sec", {count: timeDifferenceSeconds});
    } else if(timeDifferenceSeconds >= 60 && timeDifferenceSeconds <= 3599) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.min", {count: parseInt(timeDifferenceSeconds/60)});
    } else if(timeDifferenceSeconds >= 3600 && timeDifferenceSeconds <= 86399) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.hour", {count: parseInt(timeDifferenceSeconds/3600)});
    } else if(timeDifferenceSeconds >= 86400 && timeDifferenceSeconds <= 2627999) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.day", {count: parseInt(timeDifferenceSeconds/86400)});
    } else if(timeDifferenceSeconds >= 2628000 && timeDifferenceSeconds <= 31535999) {
      return I18n.t("news_feed.news_feed_helper.time_since_created.month", {count: parseInt(timeDifferenceSeconds/2628000)});
    } else {
      return I18n.t("news_feed.news_feed_helper.time_since_created.year", {count: parseInt(timeDifferenceSeconds/31536000)});
    }
  }

  get timeSinceCreated() {
    return this.constructor.sinceCreated(window.feedItemDates[this.id]);
  }
}

function newsFeedUpdateInit() {
  if (!window.newsFeedItemTemplate) {
    window.newsFeedItemTemplate = Handlebars.compile($("#news-feed-item-template").html());
  }
  if (!window.feedItemDates) {
    window.feedItemDates = {};
    for (const feedItem of $(".news-feed-item")) {
      const date = new Date(feedItem.dataset.createdAt);
      window.feedItemDates[feedItem.id] = date;
    }
  } else {
    for (const feedItem of $(".news-feed-item")) {
      if (!window.feedItemDates[feedItem.id]) {
        const date = new Date(feedItem.dataset.createdAt);
        window.feedItemDates[feedItem.id] = date; 
      }
    }
  }
  window.lastFeedItemID = $("#news-feed-pending + .news-feed-item").attr("id");
  window.numOfFeedItemsPending = 0;
  window.feedPendingDiv = $("#news-feed-pending").html(I18n.t("news_feed.index.update_pending",{count: window.numOfFeedItemsPending})).on("click", displayNewFeedItems);
  if (!window.newFeedUpdateInterval) {
    window.newFeedUpdateInterval = setInterval(updateNewsFeed, 60000);
  }
  window.feedIntervalSet = true;
}

function updateNewsFeed() {
    window.lastTimeFeedUpdated = new Date(Date.now());
    for (const timeSpan of $(".time-since-created")) {
      timeSpan.innerHTML = NewsFeedItem.sinceCreated(window.feedItemDates[timeSpan.parentElement.id]);
    }
    $.get(`/${I18n.locale}/news-feed.json?latest_id=${window.lastFeedItemID}`, function (newsFeedItems) {
      if (newsFeedItems.length > 0) {
        window.numOfFeedItemsPending += newsFeedItems.length;
        window.feedPendingDiv.html(I18n.t("news_feed.index.update_pending",{count: window.numOfFeedItemsPending}));
        if (window.feedPendingDiv.css("display") === "none") {
          window.feedPendingDiv.removeClass("hidden");
        }
        window.lastFeedItemID = `${newsFeedItems[0].id}`;
        
        itemsArray = []
        newsFeedItems.forEach(item => {
          itemsArray.push(new NewsFeedItem(item));
        });
        const newItems = $(window.newsFeedItemTemplate(itemsArray));
        newItems.insertAfter(window.feedPendingDiv);
      }
    }).fail(ajaxErrorMessage);
}

function displayNewFeedItems() {
  $(".hidden").removeClass("hidden");
  window.feedPendingDiv.addClass("hidden");
  window.numOfFeedItemsPending = 0;
  window.feedPendingDiv.html(I18n.t("news_feed.index.update_pending",{count: window.numOfFeedItemsPending}));
}

function resetFeedInterval() {
  clearInterval(window.newFeedUpdateInterval);
  window.newFeedUpdateInterval = null;
  window.feedIntervalSet = false;
}