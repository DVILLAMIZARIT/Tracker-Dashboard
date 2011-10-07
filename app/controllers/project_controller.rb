class ProjectController < ApplicationController
  def show
    @token = params[:tracker_api_key]
    @project_name = params[:project_name]

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = @token
    @projects = PivotalTracker::Project.all
    @project = @projects.find_all { |x| x.name == @project_name}.first

    # FIXME: 
    @track_budgets = [ { :label => 'trk-eligibility',     :budget => { :points => "10", :stories => ""   } },
                       { :label => 'trk-licensing',       :budget => { :points => "20", :stories => ""   } },
                       { :label => 'trk-placement',       :budget => { :points => "10", :stories => ""   } },
                       { :label => 'trk-data-conversion', :budget => { :points => "",   :stories => "10" } },
                       { :label => 'trk-sys-int',         :budget => { :points => "",   :stories => ""   } } ]
    
    @iter = @project
    @iter_stats = IterationStats.new(@iter, @track_budgets)

  end

end
