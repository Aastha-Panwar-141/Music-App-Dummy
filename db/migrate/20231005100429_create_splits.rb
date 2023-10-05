class CreateSplits < ActiveRecord::Migration[7.0]
  def change
    create_table :splits do |t|
      t.integer :requester_id
      t.integer :receiver_id
      t.string :split_type
      t.integer :percentage, default: 100
      
      t.timestamps
    end
  end
end
