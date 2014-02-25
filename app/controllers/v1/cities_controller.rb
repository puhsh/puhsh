class V1::CitiesController < V1::ApiController
  before_filter :verify_access_token
  authorize_resource
  skip_authorize_resource only: :search

  def index
    @cities = City.where(id: current_user.followed_city_ids.members)
    render_paginated @cities
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
