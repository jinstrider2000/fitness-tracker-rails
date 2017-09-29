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

  def print_time(datetime)
    ordinal_suffix = datetime.localtime.day.ordinal
    datetime.localtime.strftime("%B %-d<sup>#{ordinal_suffix}</sup>, %Y").html_safe
  end

  def print_time_index_style(datetime)
    datetime.localtime.strftime("%-m/ %d/ %y")
  end

  def link_status(link)
    request.path_info =~ /#{link}/ ? "active" : ""
  end

  def on_recent_activity?
    !!(request.path_info =~ /\/recent-activity/)
  end

  def profile_pic_url(user)
    profile_pic_file = Dir.glob(File.join("public","images","users","#{user.id}","*profilepic*")).first.match(/(?<=\/)\d+_profilepic.+/)[0]
    url("images/users/#{user.id}/#{profile_pic_file}")
  end

  def referred_by_recent_activity?
    !!(/\/recent-activity\Z/.match(request.referrer))
  end
end
