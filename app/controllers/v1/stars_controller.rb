class V1::StarsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @stars = Star.where(user_id: current_user.id).order('created_at desc')
    render json: @stars
  end
end
