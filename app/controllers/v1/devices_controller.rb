class V1::DevicesController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @device = Device.new(user: current_user, device_token: params[:device_token])
    if @device.save
      render json: @device
    else
      not_acceptable!
    end
  end
end
