class FoodsController < ApplicationController

  before_action :load_food_resource, unless: :index

  def index
    @user = User.find_by(slug: params[:user_slug])
    if @user.present?
      authorize @user
      @foods = @user.foods
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def show
    @food = food.find_by(id: params[:id])
    if @food.present?
      authorize @food
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  def edit
    @food = food.find_by(id: params[:id])
    if @food.present?
      authorize @food
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  def update
    @food = food.find_by(id: params[:id])
    if @food.present?
      authorize @food
      @food.update(food_params)
      redirect_to request.referrer, notice: "Food successfully updated"
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  def destroy
    @food = food.find_by(id: params[:id])
    if @food.present?
      authorize @food
      @food.destroy
      redirect_to request.referrer, error: "Food successfully deleted"
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :calories, :comment)
  end

  def load_food_resource
    @food = food.find_by(id: params[:id])
  end

end
