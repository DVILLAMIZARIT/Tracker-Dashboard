class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:create, :destroy]

  def create
    username = params[:session][:username]
    password = params[:session][:password]

    #begin
      user = User.authenticate(username, password)
    #rescue 
    #  logger.info "Sign in failed (TIMEOUT) for " + username
    #  sign_out
    #  flash[:notice] = "Connection to PivotalTracker timed out."
    #  redirect_to login_path
    #  return
    #end

    if user.nil?
      logger.info "Sign in failed for " + username
      sign_out
      flash[:notice] = "Invalid login or password"
      redirect_to login_path
      return
    end

    logger.info "Sign in succeeded for " + username
    sign_in user

    #go specifically to an individual project by typing in the exact url
    if not session['return-to'].nil?
     redirect_to session['return-to']
      session['return-to'] = nil

    #return to the previous project you had open if you hadn't typed in the specific project url'
    elsif not session['last-project-page'].nil?
      redirect_to session['last-project-page']

    #return to the projects page if all else fails
    else
      redirect_to projects_path

    end

  end

  def destroy
    if current_user.nil?
      logger.info "Signing out for " + current_user.username
    else
      logger.info "Signing out for <nil>"
    end
    sign_out
    redirect_to login_path
  end

end
