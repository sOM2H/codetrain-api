class Users::SessionsController < Devise::SessionsController
  include ActionController::Cookies
  before_action :authenticate_user!, only: [:me]

  respond_to :json

  def create
    user = find_resource
    if user&.valid_password?(params[:password])
      sign_in(user)
      render json: { message: "Logged in successfully", user: UserSerializer.new(user).as_json }, status: :ok
    else
      render json: { error: "Invalid login or password" }, status: :unauthorized
    end
  end

  def me
    render json: current_user, status: :ok
  end

  private

  def respond_to_on_destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end

  def find_resource
    User.find_by(login: params[:login])
  end
end
