class Users::UserActionsController < ApplicationController
  
  skip_before_action :verify_authorizated, if: [:show, :index]
  before_action :load_user_resource, unless: :index

  def show
    if @user.present?
      @blocked = current_user.blocked_by?(@user)
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def index
    @users = User.where.not(id: current_user.id)
  end

  def followers
    if @user.present?
      @users = @user.followers
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def following
    if @user.present?
      @users = @user.following
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def blocked
    if @user.present?
      @users = @user.blocked_users
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def muted
    if @user.present?
      @users = @user.muted_users
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def follow
    if @user.present?
      current_user.follow(@user)
      redirect_to request.referrer || root_path, notice: "You're following #{@user.name}"
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def unfollow
    if @user.present?
      current_user.unfollow(@user)
      redirect_to request.referrer || root_path, notice: "You've unfollowed #{@user.name}"
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def block
    if @user.present?
      current_user.block(@user)
      redirect_to request.referrer || root_path, notice: "You've blocked #{@user.name}"
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def unblock
    if @user.present?
      current_user.unblock(@user)
      redirect_to request.referrer || root_path, notice: "You've unblocked #{@user.name}"
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def mute
    if @user.present?
      current_user.mute(@user)
      redirect_to request.referrer || root_path, notice: "You've muted #{@user.name}"
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def unmute
    if @user.present?
      current_user.unmute(@user)
      redirect_to request.referrer || root_path, notice: "You've unmuted #{@user.name}"
    else
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  private

  def load_user_resource
    @user = User.find_by(slug: params[:slug])
    authorize @user
  end
  
end