class ShareRequestSerializer < ActiveModel::Serializer
  attributes :id, :requester_id, :receiver_id, :requested_percent, :status
end
