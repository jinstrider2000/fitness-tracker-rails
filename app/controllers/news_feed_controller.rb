class NewsFeedController < ApplicationController

  serialization_scope :view_context
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      respond_to do |format|
        format.html {@feed = current_user.news_feed_items}
        format.json do
          if params[:latest_created_at].present?
            render json: current_user.news_feed_items(params[:latest_created_at].gsub(/\A"|"\Z/, '')), each_serializer: NewsFeedIndexSerializer
          else
            render json: {error_message: t(".update_error")}, status: 404
          end
        end
      end
    else
      render 'application/landing'
    end
  end

end
