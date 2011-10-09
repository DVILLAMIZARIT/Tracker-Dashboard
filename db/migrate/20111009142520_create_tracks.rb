class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :label
      t.string :budget_stories
      t.string :budget_points
      t.references :project_settings

      t.timestamps
    end
    add_index :tracks, :project_settings_id
  end
end
