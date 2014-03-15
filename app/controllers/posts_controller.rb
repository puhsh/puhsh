class PostsController < ApplicationController

  def index
  end

  def show
    @post = Post.includes(:item, :user, :post_images).find(params[:id])
    @image_count = @post.post_images.count
    respond_with @post
  end
end
