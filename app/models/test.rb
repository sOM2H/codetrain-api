class Test < ApplicationRecord
  belongs_to :problem

  validates :input, :output, presence: true
end
