#!/usr/bin/env ruby

class String
  def left_justify(total_length)
    padding_length = total_length - self.length
    padding_length.times do
      insert(-1, " ")
    end
    self
  end
end

def zero_if_nil_or_negative(x)
  if x.nil?
    return 0
  elsif x < 0
    return 0
  else
    return x
  end
end

def empty_string_if_nil(x)
  if x.nil?
    return ""
  else
    return x
  end
end

class ArrayOfStories < Array
  def points
    num_points = 0
    self.each do |x|
      num_points = num_points + zero_if_nil_or_negative(x.estimate)
    end
    return num_points
  end

  def labels
    l = []
    self.each do |x|
      l = l + empty_string_if_nil(x.labels).split(',')
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
  end

  def scan_for_blockages
    @stories[:blocked] = ArrayOfStories.new( [] )
    
    (@stories[:done] + @stories[:wip] + @stories[:scheduled]).each do |story|
      if empty_string_if_nil(story.labels).match('blocked')
        @stories[:blocked].push story
      end
    end
  end

  def scan_for_surprises
    @stories[:unplanned] = ArrayOfStories.new( [] )
    
    (@stories[:done] + @stories[:wip] + @stories[:scheduled]).each do |story|
      if empty_string_if_nil(story.labels).match('added_midweek')
        @stories[:unplanned].push story
      end
    end
  end

  def scan_for_unmet_requirements
    @stories[:unmet_reqs] = ArrayOfStories.new( [] )
    
    (@stories[:wip] + @stories[:scheduled]).each do |story|
      if empty_string_if_nil(story.labels).match('!shipthisweek!')
        @stories[:unmet_reqs].push story
      end
    end
  end

end

