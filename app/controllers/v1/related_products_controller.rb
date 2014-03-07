class V1::RelatedProductsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  authorize_resource

  def index
    @post = Post.find(params[:post_id])
    @related_product = RelatedProduct.new.find_related_products(URI::escape(@post.title), @post.category_name.value, @post.subcategory_name.value)
    render json: @related_product
  end
end
