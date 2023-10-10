class Song < ApplicationRecord
  has_one_attached :file
  belongs_to :artist, foreign_key: 'user_id'
  belongs_to :album
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs
  has_many :recentyly_playeds
  after_create :initial_split
  
  has_many :song_sent_requests, foreign_key: :requester_id, class_name: 'SongRequest'
  has_many :split_requests, foreign_key: :receiver_id, class_name: 'SongSplit'
  
  has_many :song_requests, dependent: :destroy, foreign_key: :receiver_id
  has_many :song_splits

  validates :title, presence: true
  validates :genre, presence: true
  
  validates :status, inclusion: { in: %w(public private) }, presence: true
  
  private
  
  # def create_initial_split
  #   initial_split = splits.create(
  #   requester: artist,
  #   receiver:artist,
  #   split_type: 'song',
  #   percentage: 100
  #   )
  #   initial_split
  # end

  def initial_split
    # byebug
    SongSplit.create(receiver_id: artist.id, requester_id: artist.id, song_id: self.id, percentage: 100)
  end
end
