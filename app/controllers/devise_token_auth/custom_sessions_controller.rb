class DeviseTokenAuth::CustomSessionsController < DeviseTokenAuth::SessionsController
  private

  def resource_params
    params.permit(:login, :password)
  end

  def find_resource(field, value)
    User.find_by(login: value)
  end
end
