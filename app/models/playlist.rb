class Playlist < ApplicationRecord
  belongs_to :listener
  has_many :playlist_songs
end
