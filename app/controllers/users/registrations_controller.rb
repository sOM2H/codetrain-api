class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:registration).permit(:full_name, :login, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:full_name, :login, :password, :password_confirmation, :current_password)
  end
end
