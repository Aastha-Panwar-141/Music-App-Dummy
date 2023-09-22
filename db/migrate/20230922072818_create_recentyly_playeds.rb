class CreateRecentylyPlayeds < ActiveRecord::Migration[7.0]
  def change
    create_table :recentyly_playeds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.datetime :played_at

      t.timestamps
    end
  end
end
