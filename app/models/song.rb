class Song < ApplicationRecord
  has_one_attached :file
  belongs_to :artist
  belongs_to :album
  has_many :playlist_songs

  validates :title, presence:true, uniqueness: true
  validates :genre, presence:true
end
