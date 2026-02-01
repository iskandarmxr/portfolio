# ===========================================
# Application Controller
# ===========================================
class ApplicationController < ActionController::Base
  # Protect from forgery with exception (for full Rails pages)
  protect_from_forgery with: :exception

  # Helper method to get current admin user
  helper_method :current_admin, :admin_signed_in?

  private

  def current_admin
    @current_admin ||= AdminUser.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end

  def admin_signed_in?
    current_admin.present?
  end

  def authenticate_admin!
    unless admin_signed_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "Please log in to access the admin panel." }
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
      end
    end
  end
end
