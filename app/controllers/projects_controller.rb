class ProjectsController < ApplicationController

  def index
    @username = params[:username]
    @password = params[:password]

    begin
      PivotalTracker::Client.use_ssl = true
      @token = PivotalTracker::Client.token(@username, @password)
      @projects = PivotalTracker::Project.all
    rescue RestClient::Unauthorized
      flash[:notice] = "Invalid login or password"
      redirect_to(:controller=>"home", :action => 'index')
      return
    end

  end

end
