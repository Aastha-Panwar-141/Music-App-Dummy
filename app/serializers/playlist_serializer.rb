class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :title, :listener, :songs
  has_many :songs
  def listener
    object.listener.username
  end
end
