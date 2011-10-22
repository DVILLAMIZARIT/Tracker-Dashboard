class AdminController < ApplicationController
  before_filter :require_admin_access

  def index
  end

  def users
    @users = User.all
  end

  def projects
    @projects = ProjectSettings.all
  end

private

  def require_admin_access
    if !current_user.is_admin
      logger.info "User is not an admin.  Redirecting"
      redirect_to projects_path
    end
  end

end
