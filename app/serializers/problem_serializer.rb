class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :complexity, :max_score

  has_many :tags, through: :problem_tags

  def max_score
    contest_id = instance_options[:contest_id]
    current_user = instance_options[:current_user]
    object.max_score(current_user, contest_id)
  end
end
