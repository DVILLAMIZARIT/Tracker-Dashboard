class User < ActiveRecord::Base

  def is_admin
    ! [false, nil, 'f'].include?( self[:is_admin] )
  end

  def self.authenticate(username, submitted_password)
    user = find_by_username(username) || create(username)

    begin
      PivotalTracker::Client.use_ssl = true
      PivotalTracker::Client.token = nil # authentication didn't seem to work without resetting this.
      user.token = PivotalTracker::Client.token(username, submitted_password)
      projects = PivotalTracker::Project.all
      logger.info "User " + username + " has these projects: " + projects.map{|x| x.name}.join(',')
    rescue RestClient::Unauthorized
      logger.info "User " + username + " is invalid"
      return nil
    end

    user.save # This is a valid Pivotal Tracker user, so let's save
    return user
  end

  def self.authenticate_with_salt(username, cookie_salt)
    user = find_by_username(username)
    (user && user.salt == cookie_salt) ? user : nil
  end

private

  def self.create(username)
    logger.info "User " + username + " is new.  Creating salt."
    user = User.new
    user.username = username
    user.salt = random_string(SALT_LENGTH)
    return user
  end

  SALT_LENGTH = 32
  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    return str
  end

end
