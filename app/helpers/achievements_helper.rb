module AchievementsHelper

  def activity_selected?(activity_name, html_method, achievement)
    if html_method == :post || params[:action] == 'index'
      params[:activity_type].try(:capitalize) == activity_name
    else
      achievement.activity_type == activity_name
    end
  end

  def activity_selection_destination_path(activity_type)
    if params[:action] == 'index'
      user_achievements_path @user.slug, activity_type: activity_type
    else
      new_user_achievement_path @user.slug, activity_type: activity_type
    end
  end

  def activity_type_param_valid?
    Achievement.valid_activity?(params[:activity_type])
  end

  def filter_param_valid_and_other_than_completed_on?
    params[:filter] != nil && params[:filter].downcase != "completed on" && params[:activity_type].capitalize.constantize.valid_filter?(params[:filter])
  end

  def new_achievement_button
    tag.span do
      link_to t(".new_link"), new_user_achievement_path(@user.slug, activity_type: @activity_type), class: %w[btn btn-primary btn-lg], role: "button" 
    end
  end

end
