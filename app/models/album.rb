class Album < ApplicationRecord
  belongs_to :artist, foreign_key: 'user_id'
  has_many :songs, dependent: :destroy
  validates :title,presence: true,uniqueness: true
  # before_save :add_genre

  # def add_genre
  #   self.genre = genre.to_s + 'lofi'    
  # end 
end
