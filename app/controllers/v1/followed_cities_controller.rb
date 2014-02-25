class V1::FollowedCitiesController < V1::ApiController
  before_filter :skip_trackable
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @followed_cities = FollowedCity.includes(:city).where(user_id: current_user.id).order('cities.name asc')
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

  def destroy
    @followed_city = FollowedCity.find(params[:id])
    if @followed_city.destroy
      render json: @followed_city
    else
      bad_request!
    end
  end
end
