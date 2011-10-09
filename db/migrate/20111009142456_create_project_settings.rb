class CreateProjectSettings < ActiveRecord::Migration
  def change
    create_table :project_settings do |t|
      t.integer :tracker_id

      t.timestamps
    end
  end
end
