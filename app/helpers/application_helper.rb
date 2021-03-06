module ApplicationHelper

  def viewing_own_profile_while_logged_in?
    @user.id == current_user.id
  end

  def print_date(date)
    l(date, format: :long)
  end

  def print_date_index_style(date)
    l(date)
  end

  def link_status(*links)
    links.any? { |link| request.path_info =~ /#{link}/ } ? "active" : ""
  end

  def on_news_feed?
    !!(request.path_info == news_feed_path || request.path_info == root_path)
  end

  def profile_pic_path(user = nil)
    if (user.try(:persisted?) && user.profile_pic_url.present? && user.remote_profile_pic == false) || (user.try(:persisted?) && !user.profile_pic_url.present?)
      asset_path(File.join("users","#{user.id}","profile_pic"), type: :image)
    elsif user.try(:profile_pic_url) && user.remote_profile_pic == true
      user.profile_pic_url
    else
      asset_path(File.join("users","generic","profile_pic"), type: :image)
    end
  end

  def route_helpers
    Rails.application.routes.url_helpers
  end
  
end
