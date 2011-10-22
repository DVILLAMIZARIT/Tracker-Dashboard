class ProjectsController < ApplicationController
  include TrackerHelper

  def index
    current_user.increment_pageviews

    @projects = TrackerProjects.fetch(current_user)
  end

  def show
    current_user.increment_pageviews

    @project_id = params[:id].to_i
    current_user.viewed_project(@project_id)

    @projects = TrackerProjects.fetch(current_user)
    @project = TrackerProject.fetch(current_user, @project_id)
    backlog = TrackerProjectBacklog.fetch(current_user, @project_id) 
    @project_settings = ProjectSettings.find_by_tracker_id(@project_id) || 
                        ProjectSettings.create(@project_id, backlog.stories)
    @tracks = backlog.split_into_tracks(@project_settings.tracks)

    if @project_settings.tracks.count > 0 #FIXME: can't this go in the view??
      t = @project_settings.tracks.map { |x| x.updated_at }.sort.last
      @goal_date = " (As of #{t.mon}/#{t.mday})"
    else
      @goal_date = ""
    end

  end

  def edit
    current_user.increment_pageviews

    @project_id = params[:id].to_i
    current_user.viewed_project(@project_id)

    @projects = TrackerProjects.fetch(current_user)
    @project = TrackerProject.fetch(current_user, @project_id)

    backlog = TrackerProjectBacklog.fetch(current_user, @project_id) 
    @project_settings = ProjectSettings.find_by_tracker_id(@project_id) || 
                        ProjectSettings.create(@project_id, backlog.stories)

    @project_settings.create_tracks_for_new_labels(backlog.stories)
    @project_settings.tracks.build
  end

  def update
    @project_settings = ProjectSettings.find_by_tracker_id(params[:id])
    @project_settings.update_attributes(params[:project_settings]) # FIXME: CHECK FOR ERRORS

    redirect_to project_path(params[:id])
  end

end
