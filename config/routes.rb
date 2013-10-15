Puhsh::Application.routes.draw do
  root to: 'home#index'

  # Devise
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  # Main Routes
end
