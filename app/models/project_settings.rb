class ProjectSettings < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  accepts_nested_attributes_for :tracks, 
                                :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['label'].blank? }

  def self.create(project)
    ps = ProjectSettings.new
    ps.tracker_id = project.id
    ps.save

    labels = project.stories.all.map { |x| (x.labels || "").split(',') }.flatten.sort.uniq
    labels.each do |label|
      ps.tracks.create(:label => label)
    end

    return ps
  end

end
