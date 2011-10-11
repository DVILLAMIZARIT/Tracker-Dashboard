class AddStoriesSnapshotReferencesToStory < ActiveRecord::Migration
  def change
    add_column :stories, :stories_snapshot_id, :integer, :references => "stories_snapshots"
  end
end
