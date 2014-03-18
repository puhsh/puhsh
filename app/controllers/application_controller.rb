class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!
  rescue_from ActionController::RoutingError, with: :not_found!

  def peek_enabled?
    current_user_admin?
  end

  def current_user_admin?
    current_user.admin? if current_user
  end

  protected 

  def not_found!
    redirect_to 'http://www.puhsh.com/404'
  end
end
