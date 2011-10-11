class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :story_type
      t.string :labels
      t.string :name
      t.string :current_state
      t.string :estimate
      t.string :url

      t.timestamps
    end
  end
end
