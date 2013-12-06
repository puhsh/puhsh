class V1::AuthController < V1::ApiController
  def create
    fb_record = Puhsh::Facebook.find_verified_user(params[:facebook_id], request.headers['HTTP_AUTHORIZATION'])
    user_device = params[:device_type] || 'ios'
    if fb_record
      @user = User.find_for_facebook_oauth(fb_record, user_device)
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
end
