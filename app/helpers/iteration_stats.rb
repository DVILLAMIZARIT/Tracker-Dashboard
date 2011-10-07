#!/usr/bin/env ruby

class IterationStats
  attr_accessor :all_tracks

  def initialize(iter, tracks)
    initialize_tracks(iter, tracks)
    split_stories_into_tracks(iter, tracks)
    postprocess
    @all_tracks = [@track_all] + @tracks + [@track_other]
  end

  def initialize_tracks(iter, tracks_in)
    @track_all = TrackStats.new
    @track_all.name   = "All"
    @track_all.label  = nil
    @track_all.budget = { :stories => "", :points => "" }

    @track_other = TrackStats.new
    @track_other.name   = "Other"
    @track_other.label  = nil
    @track_other.budget = { :stories => "", :points => "" }

    @tracks = []
    tracks_in.each do |track_in|
      cur_track = TrackStats.new
      cur_track.name   = track_in[:label]
      cur_track.label  = track_in[:label]
      cur_track.budget = track_in[:budget]
      @tracks.push cur_track
    end
  end

  def split_stories_into_tracks(iter, tracks)
    stories = { :done      => ArrayOfStories.new( iter.stories.all(:current_state => 'accepted' ) ),
                :wip       => ArrayOfStories.new( iter.stories.all(:current_state => 'started'  ) + 
                                                  iter.stories.all(:current_state => 'finished' ) + 
                                                  iter.stories.all(:current_state => 'delivered' ) + 
                                                  iter.stories.all(:current_state => 'rejected' ) ),
                :scheduled => ArrayOfStories.new( iter.stories.all(:current_state => 'unstarted') ) }

    [:done, :wip, :scheduled].each do |key|
      stories[key].each do |story|
        @track_all.stories[key].push story
        found = false
        @tracks.each do |track|
          if !found and empty_string_if_nil(story.labels).match(track.label)
            track.stories[key].push story
            found = true
          end
        end
        @track_other.stories[key].push story if !found
      end
    end
  end

  def postprocess
    ([@track_all]+@tracks+[@track_other]).each do |track|
      track.postprocess
    end
  end

end

