class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |user|
      if user.persisted?
        profile_pic_saver = ImageService.new(user)
        flash[:warnings] << [t("users.registrations.type_error_msg")] unless profile_pic_saver.save_profile_pic(params)
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    super do |user|
      if resource_updated
        profile_pic_saver = ImageService.new(user)
        flash[:warnings] << [t("users.registrations.type_error_msg")] unless profile_pic_saver.update_profile_pic(params)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource, location: after_update_failure_for(user)
      end
    end
  end

  # DELETE /resource
  def destroy
    super do |user|
      ImageService.new(user).delete_user_image_dir
    end
  end

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
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :daily_calorie_intake_goal, :quote])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :daily_calorie_intake_goal, :quote, :current_password])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    user_path(resource.slug)
  end

  def after_update_path_for(resource)
    user_path(resource.slug)
  end

  def after_update_failure_for(resource)
    
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
