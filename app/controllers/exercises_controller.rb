class ExercisesController < ApplicationController

  before_action :load_exercise_resource, unless: :index

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present?
      authorize @user
      @exercises = @user.exercises_ordered_by(params[:filter], params[:order])
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that user doesn't exist"
    end
  end

  def show
    if @exercise.present?
      authorize @exercise
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that exercise couldn't be found"
    end
  end

  def edit
    if @exercise.present?
      authorize @exercise
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that exercise couldn't be found"
    end
  end

  def update
    if @exercise.present?
      authorize @exercise
      if !!@exercise.update(exercise_params)
        redirect_to exercise_path(@exercise), notice: "Exercise successfully updated"
      else
        flash[:warnings] = @exercise.errors.full_messages
        render :edit
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that exercise couldn't be found"
    end
  end

  def destroy
    if @exercise.present?
      authorize @exercise
      @exercise.destroy
      if referred_by_activity_feed?
        redirect_to request.referrer, notice: "Exercise successfully deleted"
      else
        redirect_to user_exercises_path, notice: "Exercise successfully deleted"
      end
    else
      skip_authorization
      redirect_to request.referrer || root_path, error: "Sorry, that exercise couldn't be found"
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:name, :calories_burned, :comment)
  end

  def load_exercise_resource
    @exercise = Exercise.find_by(id: params[:id])
  end
  
end
