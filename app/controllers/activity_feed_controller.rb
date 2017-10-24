class ActivityFeedController < ApplicationController

  def show
    if user_signed_in?
      @feed = current_user.achievement_following_timeline
    else
      render 'landing'
    end
  end

end
