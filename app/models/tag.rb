class Tag < ApplicationRecord
  has_many :problem_tags, dependent: :destroy
  has_many :problems, through: :problem_tags

  validates :name, presence: true, uniqueness: true
end
