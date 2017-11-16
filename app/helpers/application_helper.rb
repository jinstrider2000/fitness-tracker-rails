module ApplicationHelper

  def viewing_own_profile_while_logged_in?
    if @user && current_user
      @user.id == current_user.id
    else
      false
    end
  end

  def viewing_own_achievement?
    if current_user && @achievement
      current_user.id == @achievement.user.id
    else
      false
    end
  end

  def print_time(date)
    ordinal_suffix = date.day.ordinal
    date.strftime("%B %-d<sup>#{ordinal_suffix}</sup>, %Y").html_safe
  end

  def print_time_index_style(date)
    date.strftime("%-m/ %d/ %y")
  end

  def link_status(link)
    request.path_info =~ /#{link}/ ? "active" : ""
  end

  def on_recent_activity?
    !!(request.path_info =~ /\/activity-feed/)
  end

  def profile_pic_path(user)
    asset_path("users/#{user.id}/profile_pic", type: :image)
  end

  def referred_by_recent_activity?
    !!(/\/activity-feed\Z/.match(request.referrer))
  end
  
end
