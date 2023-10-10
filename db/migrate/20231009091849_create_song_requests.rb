class CreateSongRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :song_requests do |t|
      t.integer :requester_id
      t.integer :receiver_id
      t.integer :requested_percent
      t.string :status, default: 'pending'
      t.integer :price
      t.references :song_split, null: false, foreign_key: true

      t.timestamps
    end
  end
end
