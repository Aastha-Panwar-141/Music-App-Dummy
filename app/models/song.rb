class Song < ApplicationRecord
  has_one_attached :file
  has_one_attached :image
  
  belongs_to :artist, foreign_key: 'user_id'
  belongs_to :album
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs, dependent: :destroy
  has_many :recentyly_playeds, dependent: :destroy
  after_create :initial_split
  
  # has_many :song_sent_requests, foreign_key: :requester_id, class_name: 'SongRequest'
  has_many :split_requests, foreign_key: :receiver_id, class_name: 'SongSplit', dependent: :destroy
  
  # has_many :song_requests, dependent: :destroy, foreign_key: :receiver_id
  has_many :song_splits, dependent: :destroy

  validates :title, presence: true
  validates :genre, presence: true
  
  validates :status, inclusion: { in: %w(public private) }, presence: true
  
  private
  
  def initial_split
    SongSplit.create(receiver_id: artist.id, requester_id: artist.id, song_id: self.id, percentage: 100)
  end
end
