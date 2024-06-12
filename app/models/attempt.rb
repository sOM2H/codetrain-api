class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  belongs_to :language

  enum result: { pending: 0, passed: 1, wrong_answer: 2,
                 time_limit: 3, memory_limit: 4, runtime_error: 5,
                 compilation_error: 6, presentation_error: 7}

  validates :code, presence: true
  validates :result, presence: true
end