class AchievementsController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized, only: [:create]

  def new
    if params[:activity_type].try(:downcase) == "exercise"
      @achievement = Achievement.new(user: current_user, activity: Exercise.new)
    elsif params[:activity_type].try(:downcase) == "food"
      @achievement = Achievement.new(user: current_user, activity: Food.new)
    else
      @achievement = Achievement.new(user: current_user)
    end
  end

  def create
    @achievement = Achievement.new(achievement_params)
    authorize @achievement
    if @achievement.valid?
      @achievement.save
      redirect_to achievements_path
    else
      render :new
    end
  end

  def index
    @user = User.find_by(slug: params[:user_slug])
    unless user.present?
      flash.notice = "The requested user cannot be located."
      redirect_to request.referrer
    end
    @achievements = user.try(:achievements)
  end

  private

  def achievement_params
    if params[:activity_type].try(:downcase) == "exercise"
      params.require(:achievement).permit(:name, :user_id ,activity_attributes: {:name, :calories_burned, :comment})
    elsif params[:activity_type].try(:downcase) == "food"
      params.require(:achievement).permit(:name, :user_id ,activity_attributes: {:name, :calories, :comment})
    else
      params.require(:achievement)
    end
  end

end
