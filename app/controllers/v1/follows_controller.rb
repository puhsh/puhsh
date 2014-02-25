class V1::FollowsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @user = User.find_by_id(params[:user_id]) || current_user
    @follows = @user.users_following
    render_paginated @follows
  end

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
