class V1::FollowsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @follow = Follow.new(params[:follow])
    @follow.user = current_user
    
    if @follow.save
      render json: @follow
    else
      bad_request!
    end
  end
end
