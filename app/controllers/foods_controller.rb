class FoodsController < ApplicationController

  before_action :load_food_resource, unless: :index

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present?
      authorize @user
      @foods = @user.foods_ordered_by(params[:filter], params[:order])
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def show
    if @food.present?
      authorize @food
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  def edit
    if @food.present?
      authorize @food
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  def update
    if @food.present?
      authorize @food
      if !!@food.update(food_params)
        redirect_to food_path(@food), notice: "Food successfully updated"
      else
        flash[:warnings] = @food.errors.full_messages
        render :edit
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that food couldn't be found"
    end
  end

  def destroy
    if @food.present?
      authorize @food
      @food.destroy
      if referred_by_activity_feed?
        redirect_to request.referrer, notice: "Food successfully deleted"
      else
        redirect_to user_foods_path, notice: "Food successfully deleted"
      end
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
    @food = Food.find_by(id: params[:id])
  end

end
