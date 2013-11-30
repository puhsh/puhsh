Puhsh::Application.routes.draw do
  ###############
  # BEGIN ROUTES
  ###############
  
  # Root URL
  root to: 'home#index'
  
  # Dev Tools
  mount Peek::Railtie => '/peek'
  ActiveAdmin.routes(self)

  # Devise
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  ###############
  # API ROUTES
  ###############
  namespace :v1 do
    # Authentication
    post 'auth', to: 'auth#create'

    # User and Related Resources
    resources :users, except: [:new, :edit] do
      resources :devices, only: [:create]
      resources :stars, only: [:index]
      resources :invites, only: [:create]
      resources :followed_cities, only: [:create, :index]
      resources :cities, only: [:index]
      member do
        get :nearby_cities
      end
    end
    resources :devices, only: [:create]
    resources :stars, only: [:index]
    resources :invites, only: [:create]
    resources :followed_cities, only: [:index, :create]

    # Categories and Subcategories
    resources :categories, only: [:index, :show] do
      resources :subcategories, only: [:index, :show]
    end

    # Posts
    resources :posts
  end
  
  ###############
  # WEB ROUTES
  ###############
end
