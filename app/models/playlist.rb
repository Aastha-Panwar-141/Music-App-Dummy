class Playlist < ApplicationRecord
  belongs_to :listener, foreign_key: 'user_id'
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
  accepts_nested_attributes_for :songs

  validates :title, presence: true, uniqueness: true

  # has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  # has_many :followees, through: :followed_users
  # has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  # has_many :followers, through: :following_users
end
