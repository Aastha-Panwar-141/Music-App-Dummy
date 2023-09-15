class AddSongtoAlbums < ActiveRecord::Migration[7.0]
  def change
    add_reference :albums, :song, null: false, foreign_key: true
  end
end
