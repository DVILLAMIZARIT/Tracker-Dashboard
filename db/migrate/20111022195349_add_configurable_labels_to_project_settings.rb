class AddConfigurableLabelsToProjectSettings < ActiveRecord::Migration
  def self.up 
    add_column :project_settings, :red_flags_blocked_label, :string, :null => false, :default => "blocked"
    add_column :project_settings, :red_flags_unplanned_label, :string, :null => false, :default => "added_midweek"
    add_column :project_settings, :red_flags_unmet_label, :string, :null => false, :default => "ship_this_week"
  end
  def self.down 
    remove_column :project_settings, :red_flags_blocked_label
    remove_column :project_settings, :red_flags_unplanned_label
    remove_column :project_settings, :red_flags_unmet_label
  end 
end
