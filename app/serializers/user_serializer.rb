class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :user_type, :email, :fav_genre, :total_share_percentage
end
