class AddTrackingToUsers < ActiveRecord::Migration
  def self.up 
    add_column :users, :projects_viewed, :string
    add_column :users, :pageviews, :integer
  end
  def self.down 
    remove_column :users, :projects_viewed
    remove_column :users, :pageviews
  end 
end
