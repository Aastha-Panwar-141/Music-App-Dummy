class ShareRequest < ApplicationRecord
    belongs_to :requesting_artist, class_name: 'User', foreign_key: 'requester_id'
    belongs_to :receiving_artist, class_name: 'User', foreign_key: 'receiver_id'
    # belongs_to :user
end
