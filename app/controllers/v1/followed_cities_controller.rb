class V1::FollowedCitiesController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @followed_cities = current_user.followed_cities
    render json: @followed_cities
  end
  
  def create
    @followed_cities = FollowedCity.create_multiple(params[:followed_cities], current_user)
    if @followed_cities
      render json: @followed_cities
    else
      not_acceptable!
    end
  end
end
