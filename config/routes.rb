Puhsh::Application.routes.draw do
  # Dev Tools
  mount Peek::Railtie => '/peek'

  ###############
  # BEGIN ROUTES
  ###############
  
  root to: 'home#index'

  # Devise
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  ###############
  # API ROUTES
  ###############
  namespace :v1 do
    # Authentication
    post 'auth', to: 'auth#create'

    resources :users, except: [:new, :edit] do
      resources :devices, only: [:create]
    end
    resources :devices, only: [:create]
  end
end
