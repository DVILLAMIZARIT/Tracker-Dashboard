class RenameBudgetToGoal < ActiveRecord::Migration
  def self.up 
    rename_column :tracks, :budget_stories, :goal_stories
    rename_column :tracks, :budget_points,  :goal_points
  end
  def self.down 
    rename_column :tracks, :goal_stories, :budget_stories
    rename_column :tracks, :goal_points,  :budget_points
  end 
end
