class ExercisesController < ApplicationController

  def index
    @user = User.find_by(slug: params[:user_slug])
    if @user.present?
      authorize @user
      @exercises = @user.exercises
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def show
    @exercise = Exercise.find_by(id: params[:id])
    if @exercise.present?
      authorize @exercise
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that exercise couldn't be found"
    end
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    
  end
  
end
