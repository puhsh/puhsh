class V1::RelatedProductsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def index
    @post = Post.find(params[:post_id])
    @related_products = RelatedProduct.search(@post.title, current_user)
    render json: @related_products, each_serializer: RelatedProductSerializer
  end
end
