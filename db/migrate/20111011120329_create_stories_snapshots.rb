class CreateStoriesSnapshots < ActiveRecord::Migration
  def change
    create_table :stories_snapshots do |t|
      t.integer :tracker_project_id

      t.timestamps
    end
  end
end
