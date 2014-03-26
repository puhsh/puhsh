class V1::CitiesController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource
  skip_authorize_resource only: :search

  def index
    if params[:zipcode_id]
      zip = Zipcode.find_by_code(params[:zipcode_id]) || Zipcode.find_by_id(params[:zipcode_id])
      @cities = Zipcode.includes(:city).near(zip, 10).map(&:city).uniq
    else
      @cities = City.where(id: current_user.followed_city_ids.members)
    end
    render json: @cities
  end

  def search
    if params[:query]
      @cities = City.search(params[:query], params[:page], params[:per_page])
      render_paginated @cities, already_paginated: true
    else
      bad_request!('Query param is required.')
    end
  end
end
