class V1::CategoriesController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @categories = Category.limit(20)
    render json: @categories
  end

  def show
    @category = Category.find(params[:id])
    render json: @category
  end
end
