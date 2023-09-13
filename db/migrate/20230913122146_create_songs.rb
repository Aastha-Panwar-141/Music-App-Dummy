class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :genre
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
