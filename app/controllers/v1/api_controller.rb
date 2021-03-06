require 'new_relic/agent/instrumentation/controller_instrumentation'
require 'new_relic/agent/instrumentation/rails3/action_controller'
require 'new_relic/agent/instrumentation/rails3/errors'

class V1::ApiController < ActionController::Metal
  include AbstractController::Rendering
  include ActionView::Layouts
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
  rescue_from ActiveRecord::RecordNotFound, with: :not_found!
  rescue_from ActionController::RoutingError, with: :not_found!


  def render_paginated(resource, opts = {})
    defaults = { already_paginated: false, serializer: nil }
    opts = defaults.merge(opts)

    if opts[:already_paginated]
      items = resource
      total_pages = items.total_pages
      current_page = params[:page].present? ? params[:page].to_i : 1
      per_page = 25
    else
      page = params[:page] || 1
      per_page = params[:per_page] || 25
      items = resource.page(page).per(per_page)
      current_page = items.current_page
      total_pages = items.total_pages
    end

    pagination_hash = {
      prev_page_url: prev_page_url(current_page),
      next_page_url: next_page_url(total_pages, current_page),
      current_page_url: current_page_url(current_page),
      last_page_url: last_page_url(total_pages, current_page),
      first_page_url: first_page_url,
      current_page: current_page,
      total_pages: total_pages,
      per_page: per_page
    }

    if opts[:serializer]
      render json: items, root: 'items', each_serializer: opts[:serializer], meta: pagination_hash
    else
      render json: items, root: 'items', meta: pagination_hash
    end
  end

  protected

  def verify_access_token
    if current_user && current_user.access_token && current_user.access_token.token == params[:access_token]
      if current_user.access_token.expired?
        unauthorized!
      end
    else
      forbidden!('Invalid Access token')
    end
  end

  def forbidden!(extra_info = nil)
    render json: { error: 'Forbidden.', meta: { message: extra_info } }, status: :forbidden
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

  def bad_request!(extra_info = nil)
    render json: { error: 'Bad request', meta: { message: extra_info } }, status: :bad_request
  end

  def prev_page_url(current_page)
    current_page <= 1 ? nil : url_for(page: current_page - 1, format: :json)
  end

  def next_page_url(total_pages, current_page)
    current_page >= total_pages ? nil : url_for(page: current_page + 1, format: :json)
  end

  def current_page_url(current_page)
    current_page = current_page < 1 ? 1 : current_page
    url_for(page: current_page, format: :json)
  end

  def last_page_url(total_pages, current_page)
    total_pages <= 0 ? url_for(page: current_page, format: :json) : url_for(page: total_pages, format: :json)
  end

  def first_page_url
    url_for(page: 1, format: :json)
  end

  def skip_trackable
    request.env["devise.skip_trackable"] = true
  end

  def append_info_to_payload(payload)
    super
    payload[:user_id] = current_user.id rescue nil
    payload[:user_ip_address] = current_user.last_sign_in_ip rescue nil
    payload[:resource_type] = controller_name.classify rescue nil
  end
end
