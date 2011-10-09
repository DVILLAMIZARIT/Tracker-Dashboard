class SessionsController < ApplicationController
  def create
    username = params[:session][:username]
    password = params[:session][:password]

    user = User.authenticate(username, password)

    if user.nil?
      logger.info "Sign in failed for " + username
      sign_out
      flash[:notice] = "Invalid login or password"
      redirect_to login_path
    else
      logger.info "Sign in succeeded for " + username
      sign_in user
      if session['return-to'].nil?
        redirect_to projects_path
      else
        redirect_to session['return-to']
        session['return-to'] = nil
      end
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
