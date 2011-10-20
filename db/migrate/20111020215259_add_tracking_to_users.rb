class AddTrackingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :projects_viewed, :string
    add_column :users, :pageviews, :integer
  end
end
