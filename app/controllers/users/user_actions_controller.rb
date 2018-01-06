class Users::UserActionsController < ApplicationController
  
  before_action :load_and_authorize_user_resource, except: [:index]
  after_action :verify_authorized, except: [:show, :index]
  

  def show
    if @user.present?
      @blocked = current_user.blocked_by?(@user)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def index
    @users = User.where.not(id: current_user.id)
  end

  def followers
    if @user.present?
      @users = @user.followers
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def following
    if @user.present?
      @users = @user.following
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def blocked
    if @user.present?
      @users = @user.blocked_users
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def muted
    if @user.present?
      @users = @user.muted_users
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def follow
    if @user.present?
      current_user.follow(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def unfollow
    if @user.present?
      current_user.unfollow(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def block
    if @user.present?
      current_user.block(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def unblock
    if @user.present?
      current_user.unblock(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def mute
    if @user.present?
      current_user.mute(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  def unmute
    if @user.present?
      current_user.unmute(@user)
      redirect_to request.referrer || root_path, notice: t(".success_msg", first_name: @user.first_name)
    else
      redirect_to request.referrer || root_path, flash: {error: t("users.user_actions.not_found_error")}
    end
  end

  private

  def load_and_authorize_user_resource
    @user = User.find_by(slug: params[:slug])
    authorize @user
  end
  
end