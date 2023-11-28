class AlbumSerializer < ActiveModel::Serializer
  # byebug
  attributes :id, :title, :songs, :album_image
  has_many :songs, dependent: :destroy

  def album_image
    return unless object.album_image.attached?
  end
end
