class ProjectsController < ApplicationController

  def index
    if !signed_in?
      session['return-to'] = request.url
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    end

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = current_user.token
    @projects = PivotalTracker::Project.all
  end

  def show
    if !signed_in?
      session['return-to'] = request.url
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    end

    @project_id = params[:id]

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = current_user.token
    @project = PivotalTracker::Project.find(@project_id.to_i)

    # FIXME: 
    @budget_date = "10/9"
    @track_budgets = [ { :label => 'trk-eligibility',     :budget => { :points => "10", :stories => "" } },
                       { :label => 'trk-licensing',       :budget => { :points => "18", :stories => "" } },
                       { :label => 'trk-placement',       :budget => { :points =>   "", :stories => "" } },
                       { :label => 'trk-data-conversion', :budget => { :points => "15", :stories => "" } },
                       { :label => 'trk-sys-int',         :budget => { :points =>  "5", :stories => "" } } ]
    
    @iter = @project
    @iter_stats = IterationStats.new(@iter, @track_budgets)

  end

end
