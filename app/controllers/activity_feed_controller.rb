class ActivityFeedController < ApplicationController

  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def show
    if user_signed_in?
      @feed = current_user.achievement_following_timeline
    else
      render 'application/landing'
    end
  end

end
