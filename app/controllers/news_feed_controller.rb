class NewsFeedController < ApplicationController

  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @feed = current_user.achievement_following_timeline
    else
      render 'application/landing'
    end
  end

end
