class V1::OffersController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @offer = Offer.new(params[:offer])
    @offer.user = current_user

    if @offer.save
      render json: @offer
    else
      not_acceptable!
    end
  end

end
