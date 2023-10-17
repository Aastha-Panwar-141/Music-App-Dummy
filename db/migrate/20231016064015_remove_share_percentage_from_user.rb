class RemoveSharePercentageFromUser < ActiveRecord::Migration[7.0]
  def down
    add_column :users, :total_share_percentage, :integer
  end

  def up 
    remove_column :users, :total_share_percentage
  end
end
