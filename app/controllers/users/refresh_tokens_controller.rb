class Users::RefreshTokensController < ApplicationController
  before_action :authenticate_refresh_token

  def create
    new_access_token = JWT.encode(
      { user_id: @user.id, exp: 15.minutes.from_now.to_i },
      Rails.application.credentials.secret_key_base,
      'HS256'
    )

    render json: { access_token: new_access_token }, status: :ok
  end

  private

  def authenticate_refresh_token
    @user = User.find_by(refresh_token: params[:refresh_token])
    render json: { error: 'Invalid refresh token' }, status: :unauthorized unless @user
  end
end
