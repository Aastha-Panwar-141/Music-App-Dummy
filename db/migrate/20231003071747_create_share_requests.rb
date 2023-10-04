class CreateShareRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :share_requests do |t|
      t.integer :requester_id
      t.integer :receiver_id
      t.integer :requested_percent
      t.string :status, default: 'pending'
      t.integer :price

      t.timestamps
    end
  end
end
