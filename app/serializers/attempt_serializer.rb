class AttemptSerializer < ActiveModel::Serializer
  attributes :id, :problem_id, :user_id, :result, :log, :language, :code

  def result
    object.result.humanize
  end
end
