class SnapshotsController < ApplicationController
  include TrackerHelper

  def index
    return if redirect_if_not_signed_in

    @project_id  = params[:project_id]

    @project = get_single_project(current_user, @project_id.to_i)
    @snapshots = StoriesSnapshot.find_all_by_tracker_project_id(@project_id, :order => "created_at DESC")
  end

  def show
    return if redirect_if_not_signed_in

    @project_id  = params[:project_id]
    @snapshot_id = params[:id]

    @project = get_single_project(current_user, @project_id.to_i)
    @cur_stories = get_current_and_backlog_stories(current_user, @project_id.to_i)

    @snapshot = StoriesSnapshot.find(@snapshot_id)
    @snapshot.stories.build
  end

  def new
    return if redirect_if_not_signed_in

    @project_id  = params[:project_id]

    @cur_stories = get_current_and_backlog_stories(current_user, @project_id.to_i)

    StoriesSnapshot.create_from_tracker_stories(@project_id, @cur_stories)

    redirect_to project_snapshots_path(@project_id)
  end

end
