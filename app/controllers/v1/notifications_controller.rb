class V1::NotificationsController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def index
    @user = User.find_by_id(params[:user_id]) || current_user
    @notifications = Notification.where(user_id: @user.id).recent
    render_paginated @notifications
  end

  def update
    @notification = Notification.find(params[:id])
    if @notification
      @notification.mark_as_read!
      render json: @notification.reload
    else
      not_found!
    end
  end
end
