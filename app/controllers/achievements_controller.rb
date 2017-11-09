class AchievementsController < ApplicationController

  skip_after_action :verify_authorized, unless: [:create, :index]

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
    if !!@achievement.save
      redirect_to user_achievements_path(slug: current_user.slug)
    else
      flash[:warnings] = @achievement.errors.full_messages
      render :new
    end
  end

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present?
      authorize @user
      @achievements = @user.achievements_ordered_by(params[:filter], params[:order])
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist."
    end
  end

  private

  def achievement_params
    if params[:activity_type].try(:downcase) == "exercise"
      params.require(:achievement).permit(:name, :user_id, :completed_on, activity_attributes: {:name, :calories_burned, :comment})
    elsif params[:activity_type].try(:downcase) == "food"
      params.require(:achievement).permit(:name, :user_id, :completed_on, activity_attributes: {:name, :calories, :comment})
    else
      params.require(:achievement)
    end
  end

end
