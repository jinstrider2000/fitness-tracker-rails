class ExercisesController < ApplicationController

  after_action :verify_authorized

  def index
    @user = User.find_by(slug: params[:slug])
    if @user.present?
      temp_exercise = @user.achievements.build(activity_attributes:{calories_burned:0, name: ""}).activity
      authorize temp_exercise
      @exercises = @user.collection_ordered_by(params[:controller], params[:filter], params[:order])
    else
      skip_authorization
      redirect_to request.referrer || root_path, flash: {error: "Sorry, that user doesn't exist"}
    end
  end
  
end
