class V1::RelatedProductsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def index
    @post = Post.find(params[:post_id])
    @related_product = {}
    render json: @related_product
  end
end
