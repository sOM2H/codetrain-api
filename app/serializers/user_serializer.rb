class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :uid, :full_name, :role

  has_one :organization
end
