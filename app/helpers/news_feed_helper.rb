module NewsFeedHelper

  def time_since_update(achievement)
    time_dif_in_secs = (Time.zone.now - achievement.updated_at).to_i
    case
    when time_dif_in_secs.between?(0,5) 
      t "news_feed.news_feed_helper.time_since_update.now"
    when time_dif_in_secs.between?(6, 59)
      t "news_feed.news_feed_helper.time_since_update.sec", count: time_dif_in_secs
    when time_dif_in_secs.between?(60, 3599)
      t "news_feed.news_feed_helper.time_since_update.min", count: time_dif_in_secs/60
    when time_dif_in_secs.between?(3600, 86399)
      t "news_feed.news_feed_helper.time_since_update.hour", count: time_dif_in_secs/3600
    when time_dif_in_secs.between?(86400, 2627999)
      t "news_feed.news_feed_helper.time_since_update.day", count: time_dif_in_secs/86400
    when time_dif_in_secs.between?(2628000, 31535999)
      t "news_feed.news_feed_helper.time_since_update.month", count: time_dif_in_secs/2628000
    else
      t "news_feed.news_feed_helper.time_since_update.year", count: time_dif_in_secs/31536000
    end
  end

end
