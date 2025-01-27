class AttemptSerializer < ActiveModel::Serializer
  attributes :id, :problem_id, :user_id, :result, :log, :language, :code, :rounded_score

  def result
    object.result.humanize
  end

  def rounded_score
    object.rounded_score
  end
end
