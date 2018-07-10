class Users::UserActionsController < ApplicationController
  
  before_action :load_user_resource, except: [:index]
  after_action :verify_authorized, except: [:index, :most_active_today, :current_user_json]

  def current_user_json
    render json: current_user
  end

  def show
    if @user.present?
      authorize @user
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json {render json: User.where.not(id: current_user.id)}
    end
  end

  def followers
    if @user.present?
      authorize @user
      respond_to do |format|
        format.html {render :index}
        format.json {render json: @user.followers, serializer: UserIndexSerializer}
      end
    else
      skip_authorization
      respond_to do |format|
        format.html {redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}}
        format.json {render json: {error_message: t("users.user_actions.not_found_error")}, status: 404}
      end
    end
  end

  def following
    if @user.present?
      authorize @user
      respond_to do |format|
        format.html {render :index}
        format.json {render json: @user.following, serializer: UserIndexSerializer}
      end
    else
      skip_authorization
      respond_to do |format|
        format.html {redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}}
        format.json {render json: {error_message: t("users.user_actions.not_found_error")}, status: 404}
      end
    end
  end

  def blocked
    if @user.present?
      authorize @user
      respond_to do |format|
        format.html {render :index}
        format.json {render json: @user.blocked_users, serializer: UserIndexSerializer}
      end
    else
      skip_authorization
      respond_to do |format|
        format.html {redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}}
        format.json {render json: {error_message: t("users.user_actions.not_found_error")}, status: 404}
      end
    end
  end

  def muted
    if @user.present?
      authorize @user
      respond_to do |format|
        format.html {render :index}
        format.json {render json: @user.muted_users, serializer: UserIndexSerializer}
      end
    else
      skip_authorization
      respond_to do |format|
        format.html {redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}}
        format.json {render json: {error_message: t("users.user_actions.not_found_error")}, status: 404}
      end
    end
  end

  def follow
    if @user.present?
      authorize @user
      current_user.follow(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def unfollow
    if @user.present?
      authorize @user
      current_user.unfollow(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def block
    if @user.present?
      authorize @user
      current_user.block(@user)
      if request.referrer == user_url(@user.slug)
        redirect_to root_path, notice: t(".success_msg", first_name: @user.first_name)
      else
        redirect_to request.referrer, notice: t(".success_msg", first_name: @user.first_name)
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def unblock
    if @user.present?
      authorize @user
      current_user.unblock(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def mute
    if @user.present?
      authorize @user
      current_user.mute(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def unmute
    if @user.present?
      authorize @user
      current_user.unmute(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def most_active_today
    user_and_amt = User.most_active_today
    @user = user_and_amt[0]
    @amount = user_and_amt[1]
  end

  private

  def load_user_resource
    @user = User.find_by(slug: params[:slug])
  end
  
end