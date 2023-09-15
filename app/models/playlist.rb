class Playlist < ApplicationRecord
  belongs_to :listener
  has_many :playlist_songs
  validates :title, presence: true, uniqueness: true
end
