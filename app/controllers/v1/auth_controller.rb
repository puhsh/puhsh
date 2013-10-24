class V1::AuthController < V1::ApiController
  def create
    @facebook_record = Koala::Facebook::API.new(request.headers['HTTP_AUTHORIZATION']).get_object('me')
    if @facebook_record['id'] == params[:facebook_id]
      render json: {}, status: :accepted
    else
      forbidden!
    end
  end
end
