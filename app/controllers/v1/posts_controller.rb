class V1::PostsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @user = User.includes(:posts).find_by_id(params[:user_id]) || current_user
    @posts = @user.posts
    render_paginated @posts
  end

  def show
    @post = Post.find(params[:id])
    if @post
      render json: @post
    else
      not_found!
    end
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user 

    if @post.save
      render json: @post
    else
      not_acceptable!
    end
  end
end
