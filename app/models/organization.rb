class Organization < ApplicationRecord
  has_many :users
  validates :name, presence: true
  has_many :contests, dependent: :destroy

  def teachers
    User.with_role(:teacher).where(organization_id: self.id)
  end

  def students
    User.with_role(:student).where(organization_id: self.id)
  end
end
