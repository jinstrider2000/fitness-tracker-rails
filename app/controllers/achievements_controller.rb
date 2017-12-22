class AchievementsController < ApplicationController
  
  before_action :load_achievement_and_user_resource, except: [:index, :new]
  after_action :verify_authorized

  def new
    if Achievement.valid_activity?(params[:activity_type])
      @achievement = Achievement.new(activity: params[:activity_type].capitalize.constantize.new)
    else
      @achievement = Achievement.new
    end
  end

  def create
    @achievement = Achievement.new(achievement_params)
    authorize @achievement
    if @achievement.save
      redirect_to user_achievements_path(slug: current_user.slug)
    else
      flash[:warnings] = @achievement.errors.full_messages
      render :new
    end
  end

  def show
    if @achievement.present?
      authorize @achievement
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: "Sorry, that achievement couldn't be found"}
    end
  end

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present? && (params[:activity_type].empty? || Achievement.valid_activity?(params[:activity_type]))
      temp_achievement = @user.achievements.build
      authorize temp_achievement
      @activity_type = params[:activity_type].empty? ? "achievement" : params[:activity_type]
      @achievements = @user.collection_ordered_by(params[:activity_type], params[:filter], params[:order])
    else
      skip_authorization
      if @user.empty?
        flash[:warnings] << "Sorry, that user doesn't exist" 
      elsif Achievement.valid_activity?(params[:activity_type])
        flash[:warnings] << "Invalid activity type"
      end
      redirect_to request.referrer || root_path
    end
  end

  def edit
    if @achievement.present?
      authorize @achievement
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: "Sorry, that achievement couldn't be found"}
    end
  end

  def update
    if @achievement.present?
      authorize @achievement
      if @achievement.update(achievement_params)
        redirect_to achievement_path(@achievement), notice: "Achievement successfully updated"
      else
        flash[:warnings] = @achievement.errors.full_messages
        render :edit
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: "Sorry, that achievement couldn't be found"}
    end
  end

  def destroy
    if @achievement.present?
      authorize @achievement
      @achievement.destroy
      if referred_by_activity_feed?
        redirect_to request.referrer, notice: "Achievement successfully deleted"
      else
        redirect_to user_achievements_path, notice: "Achievement successfully deleted"
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: "Sorry, that Achievement couldn't be found"}
    end
  end

  private

  def load_achievement_and_user_resource
    @achievement = Achievement.find_by(id: params[:id])
    @user = @achievement.user
  end

  def achievement_params
    if params[:action] == "create"
      if params[:activity_type].try(:downcase) == "exercise"
        params.require(:achievement).permit(:name, :completed_on, :comment, activity_attributes: [:name, :calories_burned])
      elsif params[:activity_type].try(:downcase) == "food"
        params.require(:achievement).permit(:name, :completed_on, :comment, activity_attributes: [:name, :calories])
      end
    else
      if @achievement.activity_type == "Exercise"
        params.require(:achievement).permit(:name, :completed_on, :comment, activity_attributes: [:name, :calories_burned])
      elsif @achievement.activity_type == "Food"
        params.require(:achievement).permit(:name, :completed_on, :comment, activity_attributes: [:name, :calories])
      end
    end
  end

end
