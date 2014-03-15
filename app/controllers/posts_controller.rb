class PostsController < ApplicationController

  def index
  end

  def show
    @user = User.find(params[:user_id])
    if @user 
      @post = @user.posts.includes(:item, :post_images, {user: :home_city}).find(params[:id])
      @image_count = @post.post_images.count
    end
    respond_with @post
  end
end
