class PostsController < ApplicationController

  def index
    @cities = City.page(params[:page]).per(500).where('cities.posts_count > 0').order('state asc').alpha
    respond_with @cities
  end

  def show
    @user = User.friendly.find(params[:user_id])
    @city = City.friendly.find(params[:city_id])
    if @user && @city
      @post = @user.posts.includes(:item, :post_images, {user: :home_city}).friendly.where('posts.city_id = ?', @city.id).find(params[:id])
      @image_count = @post.post_images.count if @post
    end
    respond_with @post
  end
end
