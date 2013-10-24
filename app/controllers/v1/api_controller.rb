class V1::ApiController < ActionController::Metal
  include ActionController::Rendering
  include ActionController::Redirecting
  include ActionController::Renderers::All  
  include AbstractController::Callbacks
  include AbstractController::Helpers
  include ActionController::Instrumentation
  include ActionController::ParamsWrapper  
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection
  include ActionController::ForceSSL
  include ActionController::Rescue    
  include Devise::Controllers::Helpers    
  include CanCan::ControllerAdditions
  include Rails.application.routes.url_helpers

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    forbidden!
  end

  rescue_from Koala::Facebook::APIError, with: :forbidden!

  protected

  def forbidden!(extra_info = nil)
    render json: { error: 'Forbidden.', meta: extra_info }, status: :forbidden
  end

  def not_found!
    render json: { error: 'Not Found.' }, status: :not_found
  end
end
