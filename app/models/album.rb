class Album < ApplicationRecord
  belongs_to :artist, foreign_key: 'user_id', optional: true
  has_many :songs, dependent: :destroy
  validates :title, presence: true,uniqueness: true
end
