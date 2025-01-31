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

  def average_complexity
    complexities = problems.pluck(:complexity).compact
    return 0 if complexities.empty?
  
    (complexities.sum.to_f / complexities.count).round(2)
  end

  def tags
    unique_tags = Tag.joins(:problems).where(problems: { id: problems.select(:id) }).distinct
    unique_tags.map { |tag| { id: tag.id, name: tag.name } }
  end
end
