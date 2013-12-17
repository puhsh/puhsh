require 'new_relic/agent/instrumentation/controller_instrumentation'
require 'new_relic/agent/instrumentation/rails3/action_controller'
require 'new_relic/agent/instrumentation/rails3/errors'

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
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  include NewRelic::Agent::Instrumentation::Rails3::ActionController
  include NewRelic::Agent::Instrumentation::Rails3::Errors

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

  def render_paginated(resource)
    page = params[:page] || 1
    per_page = params[:per_age] || 25
    render json: resource.page(page).per(per_page)
  end

  protected

  def find_resource_for_posts
    if params[:category_id]
      @resource = Category.includes(:posts).find(params[:category_id])
    elsif params[:subcategory_id]
      @resource = Subcategory.includes(:posts).find(params[:subcategory_id])
    else
      @resource = User.includes(:posts).find_by_id(params[:user_id]) || current_user
    end
  end

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

  def not_acceptable!
    render json: { error: 'Request was not accepted.' }, status: :not_acceptable
  end
end
