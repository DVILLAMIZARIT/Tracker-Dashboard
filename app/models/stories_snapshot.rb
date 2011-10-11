class StoriesSnapshot < ActiveRecord::Base
  has_many :stories, :dependent => :destroy

  def self.create_from_tracker_stories(project_id, stories)
    ss = StoriesSnapshot.new
    ss.tracker_project_id = project_id
    ss.save

    stories.each do |cur_story|
      s=ss.stories.create(:story_type    => cur_story.story_type,
                          :labels        => cur_story.labels,
                          :name          => cur_story.name,
                          :current_state => cur_story.current_state,
                          :estimate      => cur_story.estimate,
                          :url           => cur_story.url)
      s.save
    end

    return ss
  end
end
