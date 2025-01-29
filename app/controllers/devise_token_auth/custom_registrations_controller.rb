class DeviseTokenAuth::CustomRegistrationsController < DeviseTokenAuth::RegistrationsController
  protected

  def build_resource
    @resource = User.new(sign_up_params)
  end

  private

  def sign_up_params
    params.permit(:full_name, :login, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:full_name, :login, :password, :password_confirmation, :current_password)
  end
end
