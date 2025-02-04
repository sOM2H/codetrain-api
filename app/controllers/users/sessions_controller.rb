class Users::SessionsController < Devise::SessionsController
  include ActionController::Cookies
  before_action :authenticate_user!, only: [:me]

  respond_to :json

  def create
    user = find_resource
    if user&.valid_password?(params[:password])
      sign_in(user)
      respond_with(user)
    else
      render json: { error: "Invalid login or password" }, status: :unauthorized
    end
  end

  def me
    render json: @current_user, status: :ok
  end

  private

  def respond_with(resource, _opts = {})  
    access_token = request.env['warden-jwt_auth.token']
    new_refresh_token = SecureRandom.hex(32)
    resource.update!(refresh_token: new_refresh_token, refresh_token_expires_at: Time.now + 1.day)

    cookies.signed[:refresh_token] = {
      value: new_refresh_token,
      expires: 1.day.from_now,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict
    }

    render json: { access_token: access_token }, status: :ok
  end

  def respond_to_on_destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end

  def find_resource
    User.find_by(login: params[:login])
  end
end
