class V1::AuthController < V1::ApiController
  def create
    @facebook_record = Koala::Facebook::API.new(request.headers['HTTP_AUTHORIZATION']).get_object('me')
    if @facebook_record['id'] == params[:facebook_id] && verifed?(@facebook_record)
      @user = User.find_for_facebook_oauth(@facebook_record)
      if @user
        @user.generate_access_token!
        sign_in @user, event: :token_authentication
        render json: { user: @user, access_token: @user.reload.access_token.token }
      else
        no_content!
      end
    else
      forbidden!('The requested facebook user could not be verified')
    end
  end

  protected

  def verifed?(facebook_record)
    Rails.env.production? ? @facebook_record['verified'] : true
  end
end
