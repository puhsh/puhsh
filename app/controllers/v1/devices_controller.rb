class V1::DevicesController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @existing_devices = Device.where(user_id: current_user.id, device_token: params[:device_token].delete(" "))
    
    if @existing_devices.blank?
      @device = Device.new(user: current_user, device_token: params[:device_token].delete(" "))
      @device.device_type = params[:device_type] || 'ios'
      if @device.save
        render json: @device
      else
        not_acceptable!
      end
    else
      render json: @existing_devices
    end
  end
end
