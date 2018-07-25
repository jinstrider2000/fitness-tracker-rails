class NewsFeedController < ApplicationController

  serialization_scope :view_context
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      respond_to do |format|
        format.html do
          @feed = current_user.news_feed_items
        end
        format.json do
          @feed = current_user.news_feed_items(params[:latest_post_created_at])
          render json: @feed
        end
      end
    else
      render 'application/landing'
    end
  end

end
