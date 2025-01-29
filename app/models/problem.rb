class Problem < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :problem_tags, dependent: :destroy
  has_many :tags, through: :problem_tags
  has_many :attempts, dependent: :destroy

  validates :description, presence: true

  def max_score(user)
    max_score = attempts.where(user_id: user.id).maximum(:score)
    return nil if max_score.nil?
  
    rounded_score = max_score.round(2)
    rounded_score == rounded_score.to_i ? rounded_score.to_i : rounded_score
  end
end