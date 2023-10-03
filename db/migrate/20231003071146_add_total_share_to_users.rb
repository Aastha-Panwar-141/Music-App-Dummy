class AddTotalShareToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :total_share_percentage, :integer, default: 100
  end
end
