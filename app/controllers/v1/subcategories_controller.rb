class V1::SubcategoriesController < V1::ApiController
  before_filter :skip_trackable
  before_filter :verify_access_token
  load_and_authorize_resource

  def index
    @subcategories = Subcategory.where(category_id: params[:category_id])
    render json: @subcategories
  end

  def show
    @subcategory = Subcategory.find(params[:id])
    render json: @subcategory
  end
end
