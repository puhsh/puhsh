class UsersController < ApplicationController
  # TODO this is a n+1 mess
  def show
    id = params[:user_id] || params[:id]
    @user = User.includes(:home_city, posts: [:city, :item, {post_images: :post}]).friendly.find(id)
    @city = @user.home_city
    @posts = @user.posts.page(params[:page]).per(10).recent
    respond_with @posts
  end
end
