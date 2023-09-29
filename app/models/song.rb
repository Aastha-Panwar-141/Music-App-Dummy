class Song < ApplicationRecord
  has_one_attached :file
  belongs_to :artist, foreign_key: 'user_id'
  belongs_to :album
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs
  has_many :recentyly_playeds

  validates :title, presence: true
  validates :genre, presence: true

  validates :status, inclusion: { in: %w(public private) }, presence: true

  # enum :privacy_status, { public:0, private:1 }
end
