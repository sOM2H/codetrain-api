class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  belongs_to :language
  belongs_to :contest, optional: true

  enum result: %i[pending running passed wrong_answer
                  time_limit presentation_error
                  memory_limit runtime_error compilation_error]

  validates :code, presence: true
  validates :result, presence: true

  after_create_commit :broadcast_attempt

  def broadcast_attempt
    ActionCable.server.broadcast("attempts_#{self.problem_id}_#{self.user_id}", {
      id: self.id,
      log: self.log,
      code: self.code,
      language: self.language,
      result: self.result.humanize,
      rounded_score: self.rounded_score
    })
  end

  def rounded_score
    rounded = score.round(2)
    rounded == rounded.to_i ? rounded.to_i : rounded
  end
end
