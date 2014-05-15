class PostsController < ApplicationController

  def index
    @posts = Post.includes({post_images: :post}, :item, :city, :user).page(params[:page]).per(10).recent
    respond_with @posts
  end

  def show
    @user = User.friendly.find(params[:user_id])
    @city = City.friendly.find(params[:city_id])
    if @user && @city
      @post = @user.posts.includes(:item, :post_images, {user: :home_city}).friendly.where('posts.city_id = ?', @city.id).find(params[:id])
    else
      @post = Post.find(params[:id])
    end
    @image_count = @post.post_images.count if @post
    respond_with @post
  end
end
