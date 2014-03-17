class PostsController < ApplicationController

  def index
  end

  def show
    @user = User.find(params[:user_id])
    @city = City.find(params[:city_id])
    if @user && @city
      @post = @user.posts.includes(:item, :post_images, {user: :home_city}).find(params[:id], conditions: ['city_id = ?', @city.id])
      @image_count = @post.post_images.count if @post
    end
    respond_with @post
  end
end
