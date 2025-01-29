class User < ActiveRecord::Base
  include CustomAuthenticatable

  rolify
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  
  has_many :attempts, dependent: :destroy
  belongs_to :organization

  validates :login, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  before_validation :set_uid

  def jwt_payload
    UserSerializer.new(self).as_json
  end

  private

  def set_uid
    self.uid = login if uid.blank?
  end
end
