class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :play_count, :file
  def file
    # object.avatar.map do |img|
      Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true) if object.file.attached?
    # end
  end
end
