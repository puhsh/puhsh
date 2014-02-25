class V1::StarsController < V1::ApiController
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @stars = Star.where(user_id: current_user.id)
    render json: @stars
  end
end
