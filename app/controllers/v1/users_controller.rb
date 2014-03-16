class V1::UsersController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  before_filter :forbidden!, only: [:create, :destroy]
  authorize_resource

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render json: @user.reload
    else
      bad_request!(@user.errors.messages)
    end
  end

  def destroy
  end

  def nearby_cities
    @user = User.find(params[:id])
    radius = params[:radius] || 10
    render json: @user.nearby_cities(radius).limit(100)
  end

  def activity
    if params[:without_category_ids]
      @posts = Post.includes(:item, :post_images, :city, :user)
                   .for_users_or_cities(current_user.users_following, current_user.cities_following)
                   .exclude_category_ids(params[:without_category_ids])
                   .for_sale
                   .recent
    else
      @posts = Post.includes(:item, :post_images, :city, :user)
                   .for_users_or_cities(current_user.users_following, current_user.cities_following)
                   .for_sale
                   .recent
    end
    render_paginated @posts
  end

  def watched_posts
    @posts = Post.includes(:item, :post_images, :city, :user)
                 .where('id in (?) or id in (?)', current_user.post_ids_with_offers, current_user.post_ids_with_questions)
                 .exclude_user(current_user)
                 .for_sale
                 .recent
    render_paginated @posts
  end

  def mutual_friends
    @user = User.find(params[:id])
    @mutual_friends = current_user.mutual_friends_on_puhsh(@user.uid, {keep_facebook_users: true})
    @items = [ActiveModel::ArraySerializer.new(@mutual_friends, each_serializer: FacebookUserSerializer)]
    render json: @items
  end
end
