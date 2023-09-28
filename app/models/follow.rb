class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  # belongs_to :playlist_follower, class_name: 'Playlist'
  # belongs_to :playlist_followee, class_name: 'Playlist'
  
  # to ensure a user can only follow another user once 
  # and a user can only have one follow from another user
  validates :follower_id, uniqueness: { scope: :followee_id }
  validates :followee_id, uniqueness: { scope: :follower_id }

end
