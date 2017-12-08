module AchievementsHelper

  def viewing_own_achievement?(achievement)
    current_user.id == achievement.user_id
  end
  
end
