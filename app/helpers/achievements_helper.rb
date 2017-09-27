module AchievementsHelper

  def self.display_recent_achievements
    achievements = Achievement.where("created_at > ?", 14.days.ago).order(created_at: :desc)

    # consider changing this below

    # output_buffer = ""
    # achievements.each do |achievement|
    #   if achievement.activity_type == "Food"
    #     @food = achievement.activity
    #     output_buffer << erb(:'foods/show')
    #   else
    #     @exercise = achievement.activity
    #     output_buffer << erb(:'exercises/show')
    #   end
    # end
    # output_buffer
  end
  
end
