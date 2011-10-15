class ProjectsController < ApplicationController
  include TrackerHelper

  def index
    return if redirect_if_not_signed_in

    @projects = get_all_projects(current_user)
  end

  def show
    return if redirect_if_not_signed_in

    @project_id = params[:id]

    @project = get_single_project(current_user, @project_id.to_i)

    @project_settings = ProjectSettings.find_by_tracker_id(@project_id) || ProjectSettings.create(@project)

    if @project_settings.tracks.count > 0
      t = @project_settings.tracks.map { |x| x.updated_at }.sort.last
      @budget_date = " (As of #{t.mon}/#{t.mday})"
    else
      @budget_date = ""
    end
    
    cur_stories = get_current_and_backlog_stories(current_user, @project_id.to_i)
    @tracks = split_stories_into_tracks(cur_stories, @project_settings.tracks)

  end

  def edit
    return if redirect_if_not_signed_in

    @project_id = params[:id]

    @project = get_single_project(current_user, @project_id.to_i)

    @project_settings = ProjectSettings.find_by_tracker_id(@project_id) || ProjectSettings.create(@project)
    @project_settings.tracks.build
  end

  def update
    return if redirect_if_not_signed_in

    @project_settings = ProjectSettings.find_by_tracker_id(params[:id])
    @project_settings.update_attributes(params[:project_settings]) # FIXME: CHECK FOR ERRORS

    redirect_to project_path(params[:id])
  end

end
