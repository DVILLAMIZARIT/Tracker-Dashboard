class ProjectsController < ApplicationController
  include TrackerHelper

  after_filter :update_user_analytics

  def index
    @projects = TrackerProjects.fetch(current_user)
  end

  def show
    @project_id = params[:id].to_i

    @projects = TrackerProjects.fetch(current_user)
    @project = TrackerProject.fetch(current_user, @project_id)
    backlog = TrackerProjectBacklog.fetch(current_user, @project_id) 
    @project_settings = ProjectSettings.find_by_tracker_id(@project_id) || 
                        ProjectSettings.create(@project_id, backlog.stories)
    @tracks = backlog.split_into_tracks(@project_settings.tracks)

  end

  def edit
    @project_id = params[:id].to_i

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
 
private

  def update_user_analytics
    if !current_user.nil?
      current_user.increment_pageviews
      if !params[:id].nil?
        current_user.viewed_project(params[:id].to_i)
      end
    end
  end

end

