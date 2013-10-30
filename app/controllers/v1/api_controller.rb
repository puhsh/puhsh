class V1::ApiController < ActionController::Metal
  include ActionController::Rendering
  include ActionController::Renderers::All  
  include ActionController::Redirecting
  include AbstractController::Callbacks
  include AbstractController::Helpers
  include ActionController::Instrumentation
  include ActionController::ParamsWrapper  
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection
  include ActionController::ForceSSL
  include ActionController::Rescue    
  include ActionController::Serialization
  include Devise::Controllers::Helpers    
  include CanCan::ControllerAdditions
  include Rails.application.routes.url_helpers

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    forbidden!('Access denied.')
  end

  rescue_from Koala::Facebook::APIError, with: :forbidden!

  def verify_access_token
    if current_user.access_token.token == params[:access_token]
      unauthorized! if current_user.access_token.expired?
    else
      forbidden!('Invalid Access token') 
    end
  end

  protected

  def forbidden!(extra_info = nil)
    render json: { error: 'Forbidden.', meta: extra_info }, status: :forbidden
  end

  def not_found!
    render json: { error: 'Not Found.' }, status: :not_found
  end

  def unauthorized!
    render json: { error: 'Access Token expired. Please renew it.' }, status: :unauthorized
  end

  def no_content!
    render json: { error: 'Request was processed but no data will be returned' }, status: :no_content
  end
end
