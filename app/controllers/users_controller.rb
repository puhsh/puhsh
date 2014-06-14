class UsersController < ApplicationController
  def show
    id = params[:user_id] || params[:id]
    @user = User.friendly.find(id)
    @city = @user.home_city
    @posts = @user.posts.includes({post_images: :post}, :item, :city, :user).recent.page(params[:page]).per(20)
    respond_with @posts
  end
end
