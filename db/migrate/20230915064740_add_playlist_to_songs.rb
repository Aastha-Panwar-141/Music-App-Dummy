class AddPlaylistToSongs < ActiveRecord::Migration[7.0]
  def change
    add_reference :songs, :playlist
  end
end
