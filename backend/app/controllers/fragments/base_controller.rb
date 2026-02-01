# ===========================================
# Fragments Base Controller
# Base for all HTML fragment API endpoints
# ===========================================
module Fragments
  class BaseController < ApplicationController
    # Use minimal fragment layout (no <html>, <head>, <body>)
    layout 'fragment'

    # Skip CSRF for fragment requests (CORS handles security)
    skip_before_action :verify_authenticity_token

    # Set CORS headers for frontend
    before_action :set_cors_headers
    before_action :track_visitor

    private

    def set_cors_headers
      response.headers['Access-Control-Allow-Origin'] = ENV.fetch('FRONTEND_URL', '*')
      response.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Content-Type, HX-Request, HX-Trigger, HX-Target, HX-Current-URL'
      response.headers['Access-Control-Expose-Headers'] = 'HX-Trigger, HX-Redirect, HX-Refresh'
    end

    def track_visitor
      return unless request.get? && !request.xhr?

      Visitor.create(
        session_id: session.id.to_s,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        page_visited: request.path,
        referrer: request.referrer
      )
    rescue StandardError => e
      Rails.logger.warn "Failed to track visitor: #{e.message}"
    end

    # Helper to check if request is from HTMX
    def htmx_request?
      request.headers['HX-Request'].present?
    end
  end
end
