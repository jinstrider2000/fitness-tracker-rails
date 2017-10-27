class FoodsController < ApplicationController

  def index
    @user = User.find_by(slug: params[:user_slug])
    if @user.present?
      authorize @user
      @foods = @user.foods
    else
      skip_authorization
    end
  end

  def show
    
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    
  end

end
