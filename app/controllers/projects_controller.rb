class ProjectsController < ApplicationController

  def index
    if !signed_in?
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    end

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = current_user.token
    @projects = PivotalTracker::Project.all
  end

end
