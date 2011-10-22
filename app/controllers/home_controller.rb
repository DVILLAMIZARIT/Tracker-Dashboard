class HomeController < ApplicationController
  skip_before_filter :require_login, :only => [:index]
  before_filter :require_not_logged_in

  def index
  end

private

  def require_not_logged_in
    if signed_in?
      logger.info "Already signed in.  Redirecting"
      redirect_to projects_path
    end
  end

end
