class Playlist < ApplicationRecord
  belongs_to :listener, foreign_key: 'user_id'
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs, dependent: :destroy
  
  # accepts_nested_attributes_for :songs

  validates :title, presence: true, uniqueness: true
end
