class AddPrivacyStatusToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :status, :string, default: 'public'
  end
end
