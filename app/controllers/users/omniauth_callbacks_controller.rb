class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :html

  def facebook
    @user = User.find_for_facebook_oauth(request.env['omniauth.auth'][:extra][:raw_info])

    if @user
      @user.store_facebook_access_token!(request.env['omniauth.auth']['credentials']['token'])
    end

    respond_with @user do |format|
      if @user.persisted?
        format.html { sign_in_and_redirect @user, event: :authentication }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  def after_omniauth_failure_path_for(scope)
    root_path
  end
end
