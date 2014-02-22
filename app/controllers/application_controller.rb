class ApplicationController < ActionController::Base
  protect_from_forgery

  def peek_enabled?
    current_user_admin?
  end

  def current_user_admin?
    current_user.admin? if current_user
  end

  def not_found(exception)
    render file: 'public/404.html'
  end
end
