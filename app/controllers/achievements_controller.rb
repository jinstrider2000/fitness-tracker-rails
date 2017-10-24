class AchievementsController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized

  def new
    if params[:activity_type] == "exercise"
      @achievement = current_user.achievements.build(activity: Exercise.new)
    elsif params[:activity_type] == "food"
      @achievement = current_user.achievements.build(activity: Food.new)
    else
      @achievement = Achievement.new
    end
  end

  def index
    
  end

end
