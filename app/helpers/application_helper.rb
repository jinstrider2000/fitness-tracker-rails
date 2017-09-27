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
end
