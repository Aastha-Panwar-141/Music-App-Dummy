class ShareRequestSerializer < ActiveModel::Serializer
  attributes :id, :requester_id, :requester_name, :receiver_id, :receiver_name, :requested_percent, :price, :status, :split_id, :request_type

  def receiver_name
    object.receiver.username
  end

  def requester_name
    object.requester.username
  end
end
