class V1::PostsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource
  before_filter :find_resource_for_posts, only: [:index]

  def index
    @posts = @resource.posts.includes(:item, :post_images, :city, :user).recent
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
    @post.category = @post.subcategory.category unless @post.category

    if @post.save
      render json: @post
    else
      not_acceptable!
    end
  end

  def activity
    @post = Post.find(params[:id])
    render json: @post.activity
  end
end
