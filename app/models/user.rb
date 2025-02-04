class User < ActiveRecord::Base
  include CustomAuthenticatable

  rolify
  devise :database_authenticatable, :registerable, :recoverable,
  :rememberable, :validatable

  has_many :attempts, dependent: :destroy
  has_many :contests_users, dependent: :destroy
  has_many :contests, through: :contests_users
  belongs_to :organization

  validates :login, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  before_validation :set_uid

  private

  def set_uid
    self.uid = login if uid.blank?
  end
end
