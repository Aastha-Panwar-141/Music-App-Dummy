class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :user_type, :email
end
