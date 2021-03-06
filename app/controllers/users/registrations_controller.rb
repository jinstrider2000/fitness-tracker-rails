class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_params, only: [:create, :update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |user|
      if user.persisted?
        efrain = User.find_by(id: 1)
        efrain.try(:follow, user)
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_params
    if params[:action] == "create"
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :daily_calorie_intake_goal, :quote, :profile_pic])
    else
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :daily_calorie_intake_goal, :quote, :profile_pic, :remote_profile_pic])
    end
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    user_path(resource.slug)
  end

  # The path used after update
  def after_update_path_for(resource)
    user_path(resource.slug)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
