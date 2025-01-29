Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'devise_token_auth/custom_sessions',
    registrations: 'devise_token_auth/custom_registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :problems do
        get :attempts, on: :member
        resources :tests do
          collection do
            get 'first_two', to: 'tests#first_two'
          end
        end
      end
      resources :tags
      resources :languages
      resources :attempts
    end
  end
end
