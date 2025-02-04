class Users::RefreshTokensController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_refresh_token

  def create
    new_access_token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first
    new_refresh_token = SecureRandom.hex(32)
    new_refresh_token_expires = 1.day.from_now
    @user.update!(refresh_token: new_refresh_token, refresh_token_expires_at: new_refresh_token_expires)

    cookies.signed[:refresh_token] = {
      value: new_refresh_token,
      expires: new_refresh_token_expires,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict
    }

    render json: { access_token: new_access_token }, status: :ok
  end

  private

  def authenticate_refresh_token
    refresh_token = cookies.signed[:refresh_token]
    return render json: { error: 'Refresh token required' }, status: :bad_request unless refresh_token

    @user = User.find_by(refresh_token: refresh_token)
    return render json: { error: 'Invalid refresh token' }, status: :unauthorized unless @user

    render json: { error: 'Refresh token expired' }, status: :unauthorized unless @user.refresh_token_expires_at > Time.now
  end
end
