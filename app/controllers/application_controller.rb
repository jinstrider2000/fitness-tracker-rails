class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_sign_up_parameters, if: :devise_controller?, if: [:create]
  before_action :configure_account_update_parameters, if: :devise_controller?, if: [:update]
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  protected

  def configure_sign_up_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :daily_calorie_intake_goal])
  end

  def configure_account_update_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :daily_calorie_intake_goal])
  end

  def user_not_authorized
    flash[:alert] = "Sorry, but like Hammer says, \"You can't touch this!\""
    redirect_to(request.referrer || root_path)
  end

end
