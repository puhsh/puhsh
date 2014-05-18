Puhsh::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ###############
  # BEGIN ROUTES
  ###############
  
  # Root URL
  root to: 'posts#index'
  
  # Dev Tools
  mount Peek::Railtie => '/peek'
  ActiveAdmin.routes(self)
  mount Resque::Server, at: '/resque', constraints: Puhsh::AdminConstraints
  if Rails.env.development?
    mount MailPreview, at: '/mail_view'
  end

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
      resources :notifications, only: [:index, :update]
      member do
        get :nearby_cities
        get :activity
        get :followers, to: 'followers#index'
        get :watched_posts
        get :mutual_friends
        post :confirm
      end
    end
    resources :devices, only: [:create]
    resources :stars, only: [:index]
    resources :invites, only: [:create]
    resources :followed_cities, only: [:index, :create, :destroy]
    resources :wall_posts, only: [:create]

    # Cities
    resources :cities, only: [:search] do
      collection do
        get :search
      end
      resources :users do
        resources :posts
      end
    end

    # Zip Codes
    match 'zipcodes/:zipcode_id/cities', to: 'cities#index', via: :get

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
        get :participants
      end
      resources :related_products, only: [:index]
    end
    
    # Post Images
    resources :post_images, only: [:create]

    # Flagged Posts
    resources :flagged_posts, only: [:create]

    # Offers
    resources :offers, only: [:create]

    # Questions
    resources :questions, only: [:create]

    # Follows and Followers
    resources :follows, only: [:index, :create]
    get 'followers', to: 'followers#index'

    # Messages
    resources :messages, only: [:index, :create, :update]

    # Notifications
    resources :notifications, only: [:index, :update] do
      collection do
        post :mark_all_as_read
      end
    end
  end
  
  ###############
  # WEB ROUTES
  ###############

  # Posts
  resources :posts, only: [:index]

  # Posts - SEO
  get '/posts/:city_id/:user_id/:id', to: 'posts#show', via: :get, as: 'post'
  get '/posts/:city_id', to: 'cities#show', via: :get, as: 'city'

  # States
  get '/states', to: 'states#index', via: :get, as: 'states'
  get '/states/:name', to: 'states#show', via: :get, as: 'state'

  # Users
  resources :users, only: [:show]
  
  # Users - SEO
  get '/posts/:city_id/:user_id', to: 'users#show', via: :get, as: 'city_user'

  # Download page
  get '/download', to: 'home#download', via: :get
end
