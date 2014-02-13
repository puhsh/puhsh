class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_if_production

  def peek_enabled?
    current_user_admin?
  end

  def current_user_admin?
    current_user.admin? if current_user
  end

  protected 

  def check_if_production
    redirect_to 'http://www.puhsh.com' if Rails.env.sandbox?
  end

  def authorized_api_client
    session[:authorized_api_client] = true
  end
end
