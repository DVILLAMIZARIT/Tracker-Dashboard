class AdminController < ApplicationController
  def index
    if !signed_in?
      session['return-to'] = request.url
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    elsif !current_user.is_admin
      redirect_to projects_path
      return
    end

    @users = User.all
  end
end
