class V1::AuthController < V1::ApiController
  def create
    @facebook_record = Koala::Facebook::API.new(request.headers['HTTP_AUTHORIZATION']).get_object('me')
    if @facebook_record['id'] == params[:facebook_id]
      @user = User.find_for_facebook_oauth(@facebook_record['id'])
      if @user
        @user.generate_access_token!
        render json: { user: @user, access_token: @user.reload.access_token.token }
      else
        forbidden!
      end
    else
      forbidden!
    end
  end
end
