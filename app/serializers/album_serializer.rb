class AlbumSerializer < ActiveModel::Serializer
  # byebug
  attributes :id, :title, :songs
  has_many :songs, dependent: :destroy
end
