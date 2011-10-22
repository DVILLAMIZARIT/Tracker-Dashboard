class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :require_login

private

  def require_login
    if !signed_in?
      logger.info "Not signed in.  Redirecting"
      session['return-to'] = request.url
      flash[:notice] = "Please sign in first."
      redirect_to login_path
    end
  end
 
end
