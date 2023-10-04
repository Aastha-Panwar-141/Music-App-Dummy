class ShareRequestSerializer < ActiveModel::Serializer
  attributes :id, :requester_id, :requester_name, :receiver_id, :receiver_name, :requested_percent, :price, :status

  def receiver_name
    object.receiving_artist.username
  end

  def requester_name
    object.requesting_artist.username
  end
end
