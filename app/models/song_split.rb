class SongSplit < ApplicationRecord
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many :song_requests, dependent: :destroy
  belongs_to :song

end
