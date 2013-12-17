class V1::PostsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  before_filter :find_resource_for_posts, only: [:index]
  load_and_authorize_resource

  def index
    @posts = @resource.posts
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
