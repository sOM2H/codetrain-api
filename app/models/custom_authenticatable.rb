module CustomAuthenticatable
  extend ActiveSupport::Concern

  included do
    def self.find_for_database_authentication(warden_conditions)
      login = warden_conditions[:login]
      find_by(login: login)
    end
  end
end
