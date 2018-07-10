class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :set_locale
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    respond_to do |format|
      format.html do
        flash[:error] = t "#{policy_name}.#{exception.query}", scope: :pundit, default: :default_msg
        redirect_to(request.referrer || root_path)
      end
      format.json do
        render json: {error_message: t("#{policy_name}.#{exception.query}", scope: :pundit, default: :default_msg)}, status: 403
      end
    end
  end
  # Got these methods from Rails Guides
  # http://guides.rubyonrails.org/i18n.html#managing-the-locale-across-requests
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

end
