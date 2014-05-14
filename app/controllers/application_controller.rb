class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  def peek_enabled?
    current_user_admin?
  end

  def current_user_admin?
    current_user.admin? if current_user
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def deeplinkme_url(url)
    "http://deeplink.me/#{url}"
  end

  protected 

  def not_found
    redirect_to 'http://www.puhsh.com/404' unless Rails.env.development?
  end

  def after_confirmation_path_for(resource_name, resource)
    deeplinkme_url
  end
end
