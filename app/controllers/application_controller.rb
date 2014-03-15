class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html

  def peek_enabled?
    current_user_admin?
  end

  def current_user_admin?
    current_user.admin? if current_user
  end

  protected 

  def authorized_api_client
    session[:authorized_api_client] = true
  end

  def not_found(exception)
    render file: 'public/404.html'
  end
end
