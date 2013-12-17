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
      resources :posts
      member do
        get :nearby_cities
        get :activity
      end
    end
    resources :devices, only: [:create]
    resources :stars, only: [:index]
    resources :invites, only: [:create]
    resources :followed_cities, only: [:index, :create]

    # Categories
    resources :categories, only: [:index, :show] do 
      resources :posts
    end

    # Subcategories
    resources :subcategories do
      resources :posts
    end

    # Posts
    resources :posts
  end
  
  ###############
  # WEB ROUTES
  ###############
end
