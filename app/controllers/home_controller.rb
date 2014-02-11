class HomeController < ApplicationController
  def index
    @post = Post.first
    @user = @post.user
    @post_images = @post.post_images
  end
end
