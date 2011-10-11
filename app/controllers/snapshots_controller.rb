class SnapshotsController < ApplicationController

  def index
    if !signed_in?
      session['return-to'] = request.url
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    end

    @project_id  = params[:project_id]

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = current_user.token
    @project = PivotalTracker::Project.find(@project_id.to_i)

    @cur_stories = PivotalTracker::Iteration.current(@project).stories
    PivotalTracker::Iteration.backlog(@project).each { |x| @cur_stories = @cur_stories + x.stories }

    @snapshots = StoriesSnapshot.find_all_by_tracker_project_id(@project_id, :order => "created_at DESC")
  end

  def show
    if !signed_in?
      session['return-to'] = request.url
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    end

    @project_id  = params[:project_id]
    @snapshot_id = params[:id]

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = current_user.token
    @project = PivotalTracker::Project.find(@project_id.to_i)

    @cur_stories = PivotalTracker::Iteration.current(@project).stories
    PivotalTracker::Iteration.backlog(@project).each { |x| @cur_stories = @cur_stories + x.stories }

    @snapshot = StoriesSnapshot.find(@snapshot_id)
    @snapshot.stories.build
  end

  def new
    if !signed_in?
      session['return-to'] = request.url
      logger.info "User not signed in.  Redirecting."
      flash[:notice] = "Please sign in first."
      redirect_to login_path
      return
    end

    @project_id  = params[:project_id]

    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = current_user.token
    @project = PivotalTracker::Project.find(@project_id.to_i)

    @cur_stories = PivotalTracker::Iteration.current(@project).stories
    PivotalTracker::Iteration.backlog(@project).each { |x| @cur_stories = @cur_stories + x.stories }

    @snapshot = StoriesSnapshot.create_from_tracker_stories(@project_id, @cur_stories)

    redirect_to project_snapshots_path(@project_id)
  end

end
