class ChangeStoryEstimateToInteger < ActiveRecord::Migration
  def up
    change_column :stories, :estimate, :integer
  end

  def down
    change_column :stories, :estimate, :string
  end
end
