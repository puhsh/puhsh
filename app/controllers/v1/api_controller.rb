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

  load_and_authorize_resource
  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    forbidden!(exception.message)
  end

  def forbidden!(error_message)
    respond_to do |format|
      format.json { render json: { error: error_message }, status: :forbidden }
    end
  end

  def not_found!
    respond_to do |format|
      format.json { render json: { error: 'Resource not found' }, status: :not_found }
    end
  end
end
