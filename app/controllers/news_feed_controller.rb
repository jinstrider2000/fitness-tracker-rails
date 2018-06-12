class NewsFeedController < ApplicationController

  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @feed = current_user.news_feed_items
      respond_to do |format|
        format.html
        format.json {render json: @feed}
      end
    else
      render 'application/landing'
    end
  end

end
