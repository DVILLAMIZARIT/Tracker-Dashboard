class RedFlagsController < ApplicationController
  include TrackerHelper

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
    @project_id = params[:id].to_i

    @project_settings = ProjectSettings.find_by_tracker_id(@project_id)
    @project_settings.update_attributes(params[:project_settings])

    redirect_to project_path(@project_id)
  end

end
