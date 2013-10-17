class ApplicationController < ActionController::Base
  protect_from_forgery

  def peek_enabled?
    current_user.has_role? :admin if current_user
  end

end
