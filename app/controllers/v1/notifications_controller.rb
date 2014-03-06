class V1::NotificationsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def index
    @user = User.find_by_id(params[:user_id]) || current_user
    @notifications = Notification.includes(:user, :actor, :content).where(user_id: @user.id).recent
    render_paginated @notifications
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.mark_as_read!
    render json: @notification.reload
  end

  def mark_all_as_read
    if params[:notification_id]
      @notification = Notification.find(params[:notification_id])
    end
    Notification.mark_all_as_read!(current_user, @notification)
    render json: {}
  end
end
