module ApplicationHelper

  def viewing_own_profile_while_logged_in?
    @user.id == current_user.id
  end

  def viewing_own_achievement?
    if current_user && @achievement
      current_user.id == @achievement.user.id
    else
      false
    end
  end

  def print_date(date)
    ordinal_suffix = date.day.ordinal
    date.strftime("%b. %-d<sup>#{ordinal_suffix}</sup>, %Y").html_safe
  end

  def print_date_index_style(date)
    date.strftime("%-m/ %d/ %y")
  end

  def attr_display_str(obj, attrs_to_display)
    attr_array = attrs_to_display.collect {|attr| obj.send(attr).to_s}
    attr_string = "#{attr_array[0]} <em>(Cals: "

    if obj.class == Exercise
      (attr_string + "-#{attr_array[1]})</em>").html_safe
    else
      (attr_string + "+#{attr_array[1]})</em>").html_safe
    end
  end

  def link_status(links)
    request.path_info =~ /#{links}/ ? "active" : ""
  end

  def on_activity_feed?
    !!(request.path_info =~ /activity-feed/)
  end

  def profile_pic_path(user)
    asset_path("users/#{user.id}/profile_pic", type: :image)
  end

  def referred_by_activity_feed?
    !!(request.referrer =~ /activity-feed/)
  end
  
end
