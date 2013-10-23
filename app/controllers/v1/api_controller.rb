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

  respond_to :json
end
