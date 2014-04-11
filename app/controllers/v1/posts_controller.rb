class V1::PostsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :skip_trackable
  before_filter :verify_access_token
  authorize_resource
  skip_authorize_resource only: :search
  before_filter :find_resource_for_posts, only: [:index]

  def index
    if @resource
      @posts = @resource.posts.includes(:item, {post_images: :post}, {user: :home_city})
                              .exclude_post_ids(current_user.flagged_post_ids.members)
                              .recent
    else
      @posts = Post.includes(:item, {post_images: :post}, :city, {user: :home_city})
                   .exclude_post_ids(current_user.flagged_post_ids.members)
                   .recent
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

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render json: @post
  end

  def activity
    @post = Post.find(params[:id])
    render json: @post.activity
  end

  def search
    opts = {}

    if params[:query]
      opts[:without_category_ids] = params[:without_category_ids] if params[:without_category_ids]
      @posts = Post.search(params[:query], params[:page], params[:per_page], opts)
      
      if params[:title_only]
        @posts = @posts.collect(&:title)
        render json: @posts
      else
        render_paginated @posts, already_paginated: true
      end
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
      @resource = User.includes(:posts).find_by_id(params[:user_id])
    else
      @resource = nil
    end
  end
end
