class AchievementsController < ApplicationController
  
  before_action :load_achievement_and_user_resource, except: [:index, :new, :create]
  after_action :verify_authorized

  def new
    @user = User.find_by(slug: params[:slug])
    if @user.present? && Achievement.valid_activity?(params[:activity_type])
      @achievement = Achievement.new(user: @user, activity: params[:activity_type].capitalize.constantize.new)
    else
      @achievement = Achievement.new(user: @user)
    end
    authorize @achievement
  end

  def create
    @achievement = Achievement.new(achievement_params)
    authorize @achievement
    if @achievement.save
      respond_to do |format|
        format.html {redirect user_achievements_path(slug: current_user.slug)}
        format.json {render json: @achievement}
      end
    else
      @user = current_user
      render :new
    end
  end

  def show
    if @achievement.present?
      authorize @achievement
      respond_to do |format|
        format.html
        format.json {render json: @achievement}
      end
    else
      skip_authorization
      respond_to do |format|
        format.html {redirect_to request.referrer || root_path, flash: {error: t("achievements.not_found_error")}}
        format.json {render json: {error_message: t("achievements.not_found_error")}, status: 404}
      end
    end
  end

  def next
    if @achievement.present?
      authorize @achievement
      next_achievement = @user.next_achievement(@achievement)
      render json: next_achievement[0]
    else
      skip_authorization
      render json: {error_message: t("achievements.not_found_error")}, status: 404
    end
  end

  def previous
    if @achievement.present?
      authorize @achievement
      prev_achievement = @user.prev_achievement(@achievement)
      render json: prev_achievement[0]
    else
      skip_authorization
      render json: {error_message: t("achievements.not_found_error")}, status: 404
    end
  end

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present?
      temp_achievement = @user.achievements.build
      authorize temp_achievement
      @activity_type = Achievement.valid_activity?(params[:activity_type]) ? params[:activity_type].downcase : "achievement"
      @achievements = @user.achievements_ordered_by(params[:activity_type], params[:filter], params[:order])
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("achievements.not_found_error")}
    end
  end

  def edit
    if @achievement.present?
      authorize @achievement
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("achievements.not_found_error")}
    end
  end

  def update
    if @achievement.present?
      authorize @achievement
      if @achievement.update(achievement_params)
        redirect_to achievement_path(@achievement), notice: t(".success_msg")
      else
        render :edit
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("achievements.not_found_error")}
    end
  end

  def destroy
    if @achievement.present?
      authorize @achievement
      @achievement.destroy
      redirect_to user_achievements_path(@achievement.user.slug), notice: t(".success_msg")
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("achievements.not_found_error")}
    end
  end

  private

  def load_achievement_and_user_resource
    @achievement = Achievement.find_by(id: params[:id])
    @user = @achievement.try(:user)
  end

  def achievement_params
    if params[:action] == "create"
      if params[:activity_type].try(:downcase) == "exercise"
        params.require(:achievement).permit(:name, :user_id, :completed_on, :comment, activity_attributes: [:name, :calories_burned])
      elsif params[:activity_type].try(:downcase) == "food"
        params.require(:achievement).permit(:name, :user_id, :completed_on, :comment, activity_attributes: [:name, :calories])
      end
    else
      if @achievement.activity_type == "Exercise"
        params.require(:achievement).permit(:name, :user_id, :completed_on, :comment, activity_attributes: [:name, :calories_burned])
      elsif @achievement.activity_type == "Food"
        params.require(:achievement).permit(:name, :user_id, :completed_on, :comment, activity_attributes: [:name, :calories])
      end
    end
  end

end
