class V1::WallPostsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @wall_posts = WallPost.limit(10)
    render json: @wall_posts
  end

  def create
    @wall_post = WallPost.new(params[:wall_post])
    @wall_post.user = current_user
    if @wall_post.save
      render json: @wall_post
    else
      not_acceptable!
    end
  end
end
