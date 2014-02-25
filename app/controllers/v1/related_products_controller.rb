class V1::RelatedProductsController < V1::ApiController
  before_filter :verify_access_token
  authorize_resource

  def index
    @post = Post.find(params[:post_id])
    @related_product = RelatedProduct.new.find_related_products(@post.title)
    render json: @related_product
  end
end
