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
    resources :users, except: [:new, :edit]
  end
end
