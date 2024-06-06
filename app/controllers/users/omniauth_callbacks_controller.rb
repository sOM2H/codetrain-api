module Users
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    protected

    def get_resource_from_auth_hash
      super
    end

    def assign_provider_attrs(user, auth_hash)
      super
    end
  end
end
