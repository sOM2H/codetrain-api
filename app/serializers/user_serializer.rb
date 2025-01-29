class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :uid, :full_name

  has_many :roles, through: :roles
  has_one :organization
end
