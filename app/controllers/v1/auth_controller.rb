class V1::AuthController < V1::ApiController
  def create
    fb_record = User.find_verified_user(params[:facebook_id], request.headers['HTTP_AUTHORIZATION'])
    if fb_record
      @user = User.find_for_facebook_oauth(fb_record)
      if @user
        @user.generate_access_token!
        @user.store_facebook_access_token!(request.headers['HTTP_AUTHORIZATION'])
        sign_in :user, @user, event: :token_authentication, force: true
        reset_session
        render json: { user: @user, access_token: @user.reload.access_token.token }
      else
        no_content!
      end
    else
      forbidden!('The requested facebook user could not be verified')
    end
  end
end
