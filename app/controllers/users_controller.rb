class UsersController < ApplicationController
  def show
    @user = User.includes(:posts).friendly.find(params[:user_id])
    @city = @user.home_city
    @posts = @user.posts.page(params[:page]).per(500)
    respond_with @posts
  end
end
