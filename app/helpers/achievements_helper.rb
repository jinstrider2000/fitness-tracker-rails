module AchievementsHelper

  def activity_selected?(activity_name, html_method, achievement)
    if html_method == :post 
      params[:activity_type].try(:capitalize) == activity_name
    else
      achievement.activity_type == activity_name
    end
  end

  def activity_type_param_valid?
    Achievement.valid_activity?(params[:activity_type].try(:capitalize))
  end

end
