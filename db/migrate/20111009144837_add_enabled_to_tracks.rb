class AddEnabledToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :enabled, :boolean
  end
end
