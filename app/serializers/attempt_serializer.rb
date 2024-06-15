class AttemptSerializer < ActiveModel::Serializer
  attributes :id, :problem_id, :user_id, :result, :log, :language

  def result
    object.result.humanize
  end
end
