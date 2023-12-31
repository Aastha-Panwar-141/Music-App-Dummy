class User < ApplicationRecord
  self.inheritance_column= :user_type
  
  require "securerandom" #an interface to secure random number generators
  has_secure_password #used to encrypt and authenticate passwords using BCrypt . It assumes the model has a column named password_digest
  validates :email, presence: true, uniqueness: true, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "Email address not valid"}
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create,
  length: { minimum: 6 }
  validates :user_type, presence: true, inclusion: { in: ['Listener', 'Artist'] }
  has_many :playlists, dependent: :destroy
  has_many :recentyly_playeds
  
  has_many :sent_requests, foreign_key: :requester_id, class_name: 'ShareRequest'
  has_many :split_requests, foreign_key: :receiver_id, class_name: 'Split'
  has_many :share_requests, dependent: :destroy, foreign_key: :receiver_id
  has_many :song_sent_requests, foreign_key: :requester_id, class_name: 'SongRequest'
  
  # has_many :song_requests, dependent: :destroy, foreign_key: :receiver_id
  # has_many :song_splits

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  # a user has many followees through the followed_users
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :following_users
  after_create :initial_split

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end
  
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end
  
  private

  def initial_split
    # byebug
    if self.user_type == 'Artist'
      Split.create(receiver_id: self.id, requester_id: self.id, split_type: 'Artist')
    end
  end
  
  def generate_token
    SecureRandom.hex(10)
  end
  
end
