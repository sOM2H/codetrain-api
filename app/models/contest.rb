class Contest < ApplicationRecord
  belongs_to :organization

  has_many :contests_users, dependent: :destroy
  has_many :users, through: :contests_users

  has_many :contests_problems, dependent: :destroy
  has_many :problems, through: :contests_problems

  validates :title, presence: true
  validates :description, presence: true

  def unlimited?
    start_time.nil? && end_time.nil?
  end
end
