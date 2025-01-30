class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token.nil?
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    begin
      payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first
      exp = payload['exp']

      if exp < Time.now.to_i
        return render json: { error: 'Token expired' }, status: :unauthorized
      end
    rescue JWT::DecodeError
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :login, :password, :password_confirmation])
  end
end
