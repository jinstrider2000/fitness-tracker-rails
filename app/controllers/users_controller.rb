class UsersController < ApplicationController

  skip_before_action :verify_authorizated, if: [:show, :index]
  before_action :load_and_authorize_user_resource, unless: [:show, :index]

  def show
    @blocked = current_user.blocked_by?(@user)
  end

  def index
    @users = User.where.not(id: current_user.id)
  end

  def followers
    @users = @user.followers
  end

  def following
    @users = @user.following
  end

  def blocked
    @users = @user.blocked_users
  end

  def muted
    @users = @user.muted_users
  end

  def follow
    current_user.follow(@user)
    redirect_to request.referrer || root_path, notice: "You're following #{@user.name}"
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to request.referrer || root_path, notice: "You've unfollowed #{@user.name}"
  end

  def block
    current_user.block(@user)
    redirect_to request.referrer || root_path, notice: "You've blocked #{@user.name}"
  end

  def unblock
    current_user.unblock(@user)
    redirect_to request.referrer || root_path, notice: "You've unblocked #{@user.name}"
  end

  def mute
    current_user.mute(@user)
    redirect_to request.referrer || root_path, notice: "You've muted #{@user.name}"
  end

  def unmute
    current_user.unmute(@user)
    redirect_to request.referrer || root_path, notice: "You've unmuted #{@user.name}"
  end

  private

  def load_and_authorize_user_resource
    @user = User.find_by(slug: params[:slug])
    authorize @user
  end
  
end
