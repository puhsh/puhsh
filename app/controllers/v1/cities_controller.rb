class V1::CitiesController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @cities = City.where(id: current_user.followed_city_ids.members)
    render_paginated @cities
  end
end
