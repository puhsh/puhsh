class V1::PostImagesController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def create
    @post_image = PostImage.new(params[:post_image])

    if @post_image.save
      render json: @post_image
    else
      bad_request!
    end
  end
end
