class AddColumnToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :play_count, :integer
  end
end
