class ShareRequest < ApplicationRecord
    belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
    belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
    belongs_to :split
    enum status: {pending: 'pending',accepted: 'accepted',rejected: 'rejected'}
end
