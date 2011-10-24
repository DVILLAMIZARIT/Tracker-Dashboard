module TrackerHelper
  
  class ArrayOfStories < Array
    def points
      num_points = 0
      self.each do |x|
        if x && x.estimate && x.estimate >= 0
          num_points = num_points + x.estimate
        end
      end
      return num_points
    end
  
    def labels
      l = []
      self.each do |x|
        if !x.labels.nil?
          l = l + x.labels.split(',')
        end
      end
      return l.uniq
    end
  end
  
  class TrackStats
    attr_accessor :name, :label, :goal, :stories
  
    def initialize
      @stories = { :done      => ArrayOfStories.new([]),
                   :wip       => ArrayOfStories.new([]),
                   :scheduled => ArrayOfStories.new([]) }
    end
  
    def postprocess(red_flags_labels)
      scan_for_blockages(red_flags_labels)
      scan_for_surprises(red_flags_labels)
      scan_for_unmet_requirements(red_flags_labels)
      scan_for_unestimated
    end
  
    private

    def scan_for_blockages(red_flags_labels)
      @stories[:blocked] = ArrayOfStories.new( [] )
      
      (@stories[:done] + @stories[:wip] + @stories[:scheduled]).each do |story|
        if (story.labels || "").match(red_flags_labels.red_flags_blocked_label)
          @stories[:blocked].push story
        end
      end
    end
  
    def scan_for_surprises(red_flags_labels)
      @stories[:unplanned] = ArrayOfStories.new( [] )
      
      (@stories[:done] + @stories[:wip] + @stories[:scheduled]).each do |story|
        if (story.labels || "").match(red_flags_labels.red_flags_unplanned_label)
          @stories[:unplanned].push story
        end
      end
    end
  
    def scan_for_unmet_requirements(red_flags_labels)
      @stories[:unmet_reqs] = ArrayOfStories.new( [] )
      
      (@stories[:wip] + @stories[:scheduled]).each do |story|
        if (story.labels || "").match(red_flags_labels.red_flags_unmet_label)
          @stories[:unmet_reqs].push story
        end
      end
    end
  
    def scan_for_unestimated
      @stories[:unestimated] = ArrayOfStories.new( [] )
      
      (@stories[:wip] + @stories[:scheduled]).each do |story|
        if story.estimate == -1
          @stories[:unestimated].push story
        end
      end
    end
  
  end

  class PivotalTrackerAPICacher
    def self.get_time_to_live
      case Rails.env
      when "production"
        2.minutes
      when "development"
        10.minutes
      else
        0
      end
    end
  end

  class TrackerProjects < PivotalTrackerAPICacher
    def self.fetch(user)
      ttl = self.get_time_to_live
      Rails.cache.clear if ttl == 0
      Rails.cache.fetch("user_#{user.id}_all_projects", :expires_in => ttl) do
        PivotalTracker::Client.use_ssl = true
        PivotalTracker::Client.token = user.token
        PivotalTracker::Project.all
      end
    end
  end

  class TrackerProject < PivotalTrackerAPICacher
    def self.fetch(user, project_id)
      ttl = self.get_time_to_live
      Rails.cache.clear if ttl == 0
      Rails.cache.fetch("user_#{user.id}_project_#{project_id}", :expires_in => ttl) do
        PivotalTracker::Client.use_ssl = true
        PivotalTracker::Client.token = user.token
        PivotalTracker::Project.find(project_id)
      end
    end
  end

  class TrackerProjectBacklog < PivotalTrackerAPICacher
    attr_accessor :stories

    def self.fetch(user, project_id)
      backlog = TrackerProjectBacklog.new

      ttl = self.get_time_to_live
      Rails.cache.clear if ttl == 0
      backlog.stories = Rails.cache.fetch("user_#{user.id}_project_#{project_id}_backlog", :expires_in => ttl) do
        project = TrackerProject.fetch(user, project_id)
        stories = PivotalTracker::Iteration.current(project).stories + 
                  PivotalTracker::Iteration.backlog(project).map{ |x| x.stories }.flatten
        stories
      end

      return backlog
    end

    def split_into_tracks(tracks_in, red_flag_labels)
      @track_all = TrackStats.new
      @track_all.name   = "All"
      @track_all.label  = nil
      @track_all.goal = { :stories => "", :points => "" }
  
      @track_other = TrackStats.new
      @track_other.name   = "Other"
      @track_other.label  = nil
      @track_other.goal = { :stories => "", :points => "" }
  
      @tracks = []
      tracks_in.each do |track_in|
        if track_in[:enabled]
          cur_track = TrackStats.new
          cur_track.name   = track_in[:label]
          cur_track.label  = track_in[:label]
          cur_track.goal = { :points => track_in[:goal_points], :stories => track_in[:goal_stories] }
          @tracks.push cur_track
        end
      end
  
      stories = { :done      => ArrayOfStories.new( self.stories.select{ |x| x.current_state == 'accepted'  } ),
                  :wip       => ArrayOfStories.new( self.stories.select{ |x| x.current_state == 'delivered' } + 
                                                    self.stories.select{ |x| x.current_state == 'finished'  } + 
                                                    self.stories.select{ |x| x.current_state == 'started'   } + 
                                                    self.stories.select{ |x| x.current_state == 'rejected'  } ),
                  :scheduled => ArrayOfStories.new( self.stories.select{ |x| x.current_state == 'unstarted' } ) }
  
      [:done, :wip, :scheduled].each do |key|
        stories[key].each do |story|
          @track_all.stories[key].push story
          found = false
          @tracks.each do |track|
            if !found and (story.labels || "").match(track.label)
              track.stories[key].push story
              found = true
            end
          end
          @track_other.stories[key].push story if !found
        end
      end
  
      ([@track_all]+@tracks+[@track_other]).each do |track|
        track.postprocess(red_flag_labels)
      end
  
      return [@track_all] + @tracks.sort{ |x,y| x.name <=> y.name } + [@track_other]
    end

  end

end
