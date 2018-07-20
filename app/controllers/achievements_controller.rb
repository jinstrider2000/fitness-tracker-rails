class AchievementsController < ApplicationController
  
  serialization_scope :view_context
  before_action :load_achievement_and_user_resource, except: [:index, :new, :create, :new_form_fields]
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
    achievement = Achievement.new(achievement_params)
    authorize achievement
    if achievement.save
      render json: {message: t(".success_msg", name: achievement.activity.name, activity_type: achievement.activity_type, path: achievement_path(achievement))}
    else
      render partial: 'form', locals: {html_method: :post, path: achievements_path, achievement: achievement}
    end
  end

  def show
    if @achievement.present?
      authorize @achievement
      respond_to do |format|
        format.html
        format.json {render json: @achievement, serializer: AchievementShowSerializer}
      end
    else
      skip_authorization
      respond_to do |format|
        format.html {redirect_to(request.referrer || root_path, flash: {error: t("achievements.not_found_error")})}
        format.json {render json: {error_message: t("achievements.not_found_error")}, status: 404}
      end
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
          render json: {message: t(".success_msg", name: @achievement.activity.name, activity_type: @achievement.activity_type, path: achievement_path(@achievement))}
      else
          render partial: 'form', locals: {html_method: :patch, path: achievement_path(@achievement), achievement: @achievement}
      end
    else
      skip_authorization
      render json: {error_message: t("achievements.not_found_error")}
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

  def next_id
    user_given_by_slug = User.find_by(slug: params[:slug])
    if @achievement.present? && @user == user_given_by_slug
      authorize @achievement
      render json: @user.next_achievement_id(@achievement)
    else
      skip_authorization
      render json: {error_message: t("achievements.not_found_error")}, status: 404
    end
  end

  def previous_id
    user_given_by_slug = User.find_by(slug: params[:slug])
    if @achievement.present? && @user == user_given_by_slug
      authorize @achievement
      render json: @user.prev_achievement_id(@achievement)
    else
      skip_authorization
      render json: {error_message: t("achievements.not_found_error")}, status: 404
    end
  end

  def new_form_fields
    user = User.find_by(slug: params[:slug])
    if user.present? && Achievement.valid_activity?(params[:activity_type])
      achievement = Achievement.new(user: user, activity: params[:activity_type].capitalize.constantize.new)
      authorize achievement
      render partial: "form", locals: {html_method: :post, path: achievements_path, achievement: achievement}
    else
      render json: {error_message: t(".not_found_error")}, status: 404
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
