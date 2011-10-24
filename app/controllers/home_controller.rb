class HomeController < ApplicationController
  skip_before_filter :require_login, :only => [:index]
  before_filter :require_not_logged_in

  def index
  end

private

  def require_not_logged_in
    if signed_in?
      logger.info "Already signed in.  Redirecting"
      # TD checks if I have a cookie set to return me to a particular project.
      # If yes, take me to that project
      # If no, then take me to the dashboard
      if session['return-to-project'].nil?
        redirect_to projects_path
      else
        redirect_to session['return-to-project']
      end
    end
  end

end
