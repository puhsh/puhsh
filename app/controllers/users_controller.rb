class UsersController < ApplicationController
  # TODO this is a n+1 mess
  def show
    @user = User.includes(:home_city, posts: [:city, :item, {post_images: :post}]).friendly.find(params[:user_id])
    @city = @user.home_city
    @posts = @user.posts.page(params[:page]).per(10).recent
    respond_with @posts
  end
end
