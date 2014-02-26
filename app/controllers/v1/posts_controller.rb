class V1::PostsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource
  skip_authorize_resource only: :search
  before_filter :find_resource_for_posts, only: [:index]

  def index
    if @resource
      @posts = @resource.posts.includes(:item, :post_images, :city, :user).recent
    else
      @posts = Post.includes(:item, :post_images, :city, :user).recent
    end
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
      bad_request!
    end
  end

  def activity
    @post = Post.find(params[:id])
    render json: @post.activity
  end

  def search
    if params[:query]
      @posts = Post.search(params[:query], params[:page], params[:per_page])
      render_paginated @posts, already_paginated: true
    else
      bad_request!('Query param is required.')
    end
  end

  def participants
    @post = Post.find(params[:id])
    @users = User.where(id: @post.activity.collect(&:user_id)).where('id != ?', @post.user_id)
    render json: @users, each_serializer: SimpleUserSerializer
  end

  protected 

  def find_resource_for_posts
    if params[:category_id]
      @resource = Category.includes(:posts).find(params[:category_id])
    elsif params[:subcategory_id]
      @resource = Subcategory.includes(:posts).find(params[:subcategory_id])
    elsif params[:user_id]
      @resource = User.find_by_id(params[:user_id])
    else
      @resource = nil
    end
  end

end
