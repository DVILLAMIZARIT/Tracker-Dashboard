module SessionsHelper

  def sign_in(user)
    logger.info "Signing in " + user.username
    cookies.permanent.signed[:remember_token] = [user.username, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    if current_user.nil?
      return false
    end
    @current_user.save # bump up the 'updated_at' timestamp, which we're using to track activity
    return true
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_if_not_signed_in
    if !signed_in?
      session['return-to'] = request.url
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return true
    end
    return false
  end

private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

end
