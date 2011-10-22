class SnapshotsController < ApplicationController
  include TrackerHelper

  after_filter :update_user_analytics

  def index
    @project_id  = params[:project_id].to_i

    @snapshots = StoriesSnapshot.find_all_by_tracker_project_id(@project_id, :order => "created_at DESC")
    if @snapshots.empty?
      backlog = TrackerProjectBacklog.fetch(current_user, @project_id)
      @snapshots = [ StoriesSnapshot.create_from_tracker_stories(@project_id, backlog.stories) ]
    end

    redirect_to project_snapshot_path(@project_id, @snapshots.first.id)
  end

  def show
    @project_id  = params[:project_id].to_i
    @snapshot_id = params[:id].to_i

    @projects = TrackerProjects.fetch(current_user)
    @project = TrackerProject.fetch(current_user, @project_id)
    backlog = TrackerProjectBacklog.fetch(current_user, @project_id)
    @cur_stories = backlog.stories

    @snapshots = StoriesSnapshot.find_all_by_tracker_project_id(@project_id, :order => "created_at DESC")
    @snapshot = StoriesSnapshot.find(@snapshot_id)
    @snapshot.stories.build
  end

  def new
    @project_id  = params[:project_id].to_i

    backlog = TrackerProjectBacklog.fetch(current_user, @project_id)
    @snapshot = StoriesSnapshot.create_from_tracker_stories(@project_id, backlog.stories)

    redirect_to project_snapshot_path(@project_id, @snapshot.id)
  end
 
private

  def update_user_analytics
    if !current_user.nil?
      current_user.increment_pageviews
      if !params[:project_id].nil?
        current_user.viewed_project(params[:project_id].to_i)
      end
    end
  end

end
