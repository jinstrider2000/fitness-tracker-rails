module ApplicationHelper

  def viewing_own_profile_while_logged_in?
    @user.id == current_user.id
  end

  def print_date(date)
    ordinal_suffix = date.day.ordinal
    date.strftime("%b. %-d<sup>#{ordinal_suffix}</sup>, %Y").html_safe
  end

  def print_date_index_style(date)
    date.strftime("%-m/%d/%y")
  end

  def link_status(*links)
    links.any? { |link| request.path_info =~ /#{link}/ } ? "active" : ""
  end

  def on_activity_feed?
    !!(request.path_info =~ /activity-feed/)
  end

  def profile_pic_path(user = nil)
    if user.try(:persisted?)
      asset_path(File.join("users","#{user.id}","profile_pic"), type: :image)
    else
      asset_path(File.join("users","generic","profile_pic"), type: :image)
    end
  end

  def referred_by_activity_feed?
    !!(request.referrer =~ /activity-feed/)
  end

  def route_helpers
    Rails.application.routes.url_helpers
  end
  
end
