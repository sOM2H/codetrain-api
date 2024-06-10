class Problem < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :problem_tags, dependent: :destroy
  has_many :tags, through: :problem_tags

  validates :description, presence: true
end