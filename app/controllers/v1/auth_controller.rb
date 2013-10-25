class V1::AuthController < V1::ApiController
  def create
    @facebook_record = Koala::Facebook::API.new(request.headers['HTTP_AUTHORIZATION']).get_object('me')
    if @facebook_record['id'] == params[:facebook_id]
      @user = User.find_for_facebook_oauth(@facebook_record['id'])
      @user.generate_access_token! if @user
      render json: @user
    else
      forbidden!
    end
  end
end
