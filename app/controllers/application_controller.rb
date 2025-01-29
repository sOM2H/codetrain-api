class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token && JWT.decode(token, Rails.application.credentials.secret_key_base).first
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :login, :password, :password_confirmation])
  end
end
