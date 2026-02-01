# ===========================================
# Health Check Controller
# ===========================================
class HealthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    # Check database connection
    ActiveRecord::Base.connection.execute("SELECT 1")

    render json: {
      status: "healthy",
      timestamp: Time.current.iso8601,
      database: "connected",
      version: Rails.version
    }, status: :ok
  rescue StandardError => e
    render json: {
      status: "unhealthy",
      timestamp: Time.current.iso8601,
      error: e.message
    }, status: :service_unavailable
  end
end
