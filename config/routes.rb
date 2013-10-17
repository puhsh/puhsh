Puhsh::Application.routes.draw do
  # Dev Tools
  mount Peek::Railtie => '/peek'

  ###############
  # BEGIN ROUTES
  ###############
  
  root to: 'home#index'

  # Devise
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  # Main Routes
end
