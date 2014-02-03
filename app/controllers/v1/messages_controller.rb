class V1::MessagesController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def index
    @sender = current_user
    @recipient = User.find_by_id(params[:recipient_id]) if params[:recipient_id]

    if @recipient
      @messages = Message.includes(:sender, :recipient).between_sender_and_recipient(@sender, @recipient).recent
    else
      @messages = Message.includes(:sender, :recipient).by_sender(@sender).exclude_recipient(@sender).grouped_by_recipient.recent
    end

    render_paginated @messages
  end
end
