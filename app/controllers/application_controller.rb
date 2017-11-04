class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  protected

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: :pundit, default: :default_msg
    redirect_to(request.referrer || root_path)
  end

  def referred_by_activity_feed?
    !!request.referrer =~ /activity-feed/
  end

end
