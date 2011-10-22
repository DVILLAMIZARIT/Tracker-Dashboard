class ProjectSettings < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy, :order => 'label ASC'
  accepts_nested_attributes_for :tracks, 
                                :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['label'].blank? }

  def self.create(project_id, stories)
    ps = ProjectSettings.new
    ps.tracker_id = project_id
    ps.save

    # Find all the labels.  Also find the 3 most-common labels.  Create 
    # tracks for all labels, and enable those that are the most common ones.
    all_labels = stories.map { |x| (x.labels || "").split(',') }.flatten.sort
    labels = all_labels.uniq
    common_labels = labels.map{ |x| { :count => all_labels.count(x), :label => x } }.sort{ |x,y| y[:count] <=> x[:count] }
    common_labels = common_labels[0..2].map{ |x| x[:label] }
    labels.each do |label|
      ps.tracks.create(:label => label, :enabled => common_labels.include?(label))
    end

    return ps
  end

  def create_tracks_for_new_labels(stories)
    project_labels = stories.map { |x| (x.labels || "").split(',') }.flatten.sort.uniq
    self_labels = self.tracks.map { |t| t.label }
    (project_labels - self_labels).each do |label|
      self.tracks.create(:label => label)
    end
  end

end
