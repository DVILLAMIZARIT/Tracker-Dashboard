#!/usr/bin/env ruby

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

