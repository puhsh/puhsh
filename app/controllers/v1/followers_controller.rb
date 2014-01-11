class V1::FollowersController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource class: 'Follow'

  def index
    @user = User.find_by_id(params[:user_id]) || current_user
    @followers = @user.users_followers
    render_paginated @followers
  end
end
