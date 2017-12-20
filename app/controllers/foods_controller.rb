class FoodsController < ApplicationController

  after_action :verify_authorized

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present?
      temp_food = Food.new
      temp_achievement = Achievement.new(user: @user)
      temp_food.achievement = temp_achievement
      authorize temp_food
      @foods = @user.collection_ordered_by(params[:controller], params[:filter], params[:order])
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: "Sorry, that user doesn't exist"}
    end
  end

end