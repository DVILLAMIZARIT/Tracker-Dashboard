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
    attr_accessor :name, :label, :budget, :stories
  
    def initialize
      @stories = { :done      => ArrayOfStories.new([]),
                   :wip       => ArrayOfStories.new([]),
                   :scheduled => ArrayOfStories.new([]) }
    end
  
    def postprocess
      scan_for_blockages
      scan_for_surprises
      scan_for_unmet_requirements
      scan_for_unestimated
    end
  
    def scan_for_blockages
      @stories[:blocked] = ArrayOfStories.new( [] )
      
      (@stories[:done] + @stories[:wip] + @stories[:scheduled]).each do |story|
        if (story.labels || "").match('blocked')
          @stories[:blocked].push story
        end
      end
    end
  
    def scan_for_surprises
      @stories[:unplanned] = ArrayOfStories.new( [] )
      
      (@stories[:done] + @stories[:wip] + @stories[:scheduled]).each do |story|
        if (story.labels || "").match('added_midweek')
          @stories[:unplanned].push story
        end
      end
    end
  
    def scan_for_unmet_requirements
      @stories[:unmet_reqs] = ArrayOfStories.new( [] )
      
      (@stories[:wip] + @stories[:scheduled]).each do |story|
        if (story.labels || "").match('!shipthisweek!')
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

  def get_all_projects(user)
    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = user.token
    return PivotalTracker::Project.all
  end

  def get_single_project(user, project_id)
    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token = user.token
    return PivotalTracker::Project.find(project_id)
  end

  def get_current_and_backlog_stories(user, project_id)
    project = get_single_project(user, project_id)
    stories = PivotalTracker::Iteration.current(project).stories
    PivotalTracker::Iteration.backlog(project).each { |x| stories = stories + x.stories }
    return stories
  end

  def split_stories_into_tracks(stories_in, tracks_in)
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
      if track_in[:enabled]
        cur_track = TrackStats.new
        cur_track.name   = track_in[:label]
        cur_track.label  = track_in[:label]
        cur_track.budget = { :points => track_in[:budget_points], :stories => track_in[:budget_stories] }
        @tracks.push cur_track
      end
    end

    stories = { :done      => ArrayOfStories.new( stories_in.select{ |x| x.current_state == 'accepted'  } ),
                :wip       => ArrayOfStories.new( stories_in.select{ |x| x.current_state == 'delivered' } + 
                                                  stories_in.select{ |x| x.current_state == 'finished'  } + 
                                                  stories_in.select{ |x| x.current_state == 'started'   } + 
                                                  stories_in.select{ |x| x.current_state == 'rejected'  } ),
                :scheduled => ArrayOfStories.new( stories_in.select{ |x| x.current_state == 'unstarted' } ) }

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
      track.postprocess
    end

    return [@track_all] + @tracks.sort{ |x,y| x.name <=> y.name } + [@track_other]
  end

end
