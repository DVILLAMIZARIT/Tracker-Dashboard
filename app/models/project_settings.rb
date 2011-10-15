class ProjectSettings < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy, :order => 'label ASC'
  accepts_nested_attributes_for :tracks, 
                                :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['label'].blank? }

  def self.create(project_id, stories)
    ps = ProjectSettings.new
    ps.tracker_id = project_id
    ps.save

    labels = stories.map { |x| (x.labels || "").split(',') }.flatten.sort.uniq
    labels.each do |label|
      ps.tracks.create(:label => label)
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
