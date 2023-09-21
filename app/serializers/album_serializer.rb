class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :songs
  has_many :songs
end
