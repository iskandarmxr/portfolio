# ===========================================
# Sessions Controller (Authentication)
# ===========================================
class SessionsController < ApplicationController
  layout 'admin'

  def new
    redirect_to admin_root_path if admin_signed_in?
  end

  def create
    admin = AdminUser.find_by(email: params[:email]&.downcase)

    if admin&.authenticate(params[:password])
      session[:admin_user_id] = admin.id
      redirect_to admin_root_path, notice: "Welcome back, #{admin.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_user_id)
    @current_admin = nil
    redirect_to login_path, notice: "You have been logged out."
  end
end
