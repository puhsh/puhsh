class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :html

  def facebook
    @user = User.find_for_facebook_oauth(request.env['omniauth.auth'])

    respond_with @user do |format|
      if @user.persisted?
        format.html { sign_in_and_redirect @user, event: :authentication }
      else
        format.html { redirect_to root_path }
      end
    end
  end

end
