class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :attempts, dependent: :destroy

  validates :login, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  before_validation :set_uid

  private

  def set_uid
    self.uid = login if uid.blank?
  end
end
