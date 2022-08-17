class ApplicationController < ActionController::Base
  # https://github.com/heartcombo/devise/tree/v3.0.0.rc#strong-parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
  end
end
