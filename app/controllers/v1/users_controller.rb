class V1::UsersController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  before_filter :forbidden!, only: [:create, :destroy]
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render json: @user.reload
    else
      not_acceptable!
    end
  end

  def destroy
  end

  def nearby_cities
    @user = User.find(params[:id])
    render json: @user.nearby_cities
  end

  def activity
    @posts = Post.includes(:items, :user).for_cities(current_user.cities_following).exclude_user(current_user).recent
    render_paginated @posts
  end
end
