class ChangeStoryEstimateToInteger < ActiveRecord::Migration
  def up
    remove_column :stories, :estimate
    add_column    :stories, :estimate, :integer
  end

  def down
    remove_column :stories, :estimate
    add_column    :stories, :estimate, :string
  end
end
