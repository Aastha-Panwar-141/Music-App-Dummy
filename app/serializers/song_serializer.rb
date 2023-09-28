class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :artist_name, :play_count, :status, :file
  def file
    # object.avatar.map do |img|
    Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true) if object.file.attached?
    # end
  end
  
  def artist_name
    object.artist.username
  end
end
