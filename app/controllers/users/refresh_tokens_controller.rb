class Users::RefreshTokensController < ApplicationController
  before_action :authenticate_refresh_token

  def create
    new_access_token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first
    new_refresh_token = SecureRandom.hex(32)
    @user.update!(refresh_token: new_refresh_token)

    render json: { access_token: new_access_token, refresh_token: new_refresh_token}, status: :ok
  end

  private

  def authenticate_refresh_token
    refresh_token = params[:refresh_token]
    return render json: { error: 'Refresh token required' }, status: :bad_request unless refresh_token

    @user = User.find_by(refresh_token: refresh_token)
    
    render json: { error: 'Invalid refresh token' }, status: :unauthorized unless @user
  end
end
