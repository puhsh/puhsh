class V1::FlaggedPostsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @flagged_post = FlaggedPost.new(params[:flagged_post])
    @flagged_post.user = current_user
    if @flagged_post.save
      render json: @flagged_post
    else
      bad_request!
    end
  end
end
