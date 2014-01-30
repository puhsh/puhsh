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
      resources :follows
      member do
        get :nearby_cities
        get :activity
        get :followers, to: 'followers#index'
      end
    end
    resources :devices, only: [:create]
    resources :stars, only: [:index]
    resources :invites, only: [:create]
    resources :followed_cities, only: [:index, :create]
    resources :wall_posts, only: [:create]

    # Cities
    resources :cities, only: [:search] do
      collection do
        get :search
      end
    end

    # Categories
    resources :categories, only: [:index, :show] do 
      resources :posts
    end

    # Subcategories
    resources :subcategories do
      resources :posts
    end

    # Posts
    resources :posts do
      collection do
        get :search
      end
      member do
        get :activity
      end
    end

    # Flagged Posts
    resources :flagged_posts, only: [:create]

    # Offers
    resources :offers, only: [:create]

    # Questions
    resources :questions, only: [:create]

    # Follows and Followers
    resources :follows, only: [:index, :create]
    get 'followers', to: 'followers#index'
  end
  
  ###############
  # WEB ROUTES
  ###############
end
