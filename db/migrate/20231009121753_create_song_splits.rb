class CreateSongSplits < ActiveRecord::Migration[7.0]
  def change
    create_table :song_splits do |t|
      t.integer :requester_id
      t.integer :receiver_id
      t.integer :percentage
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end
  end
end
