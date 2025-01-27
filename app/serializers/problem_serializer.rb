class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :complexity, :max_score

  has_many :tags, through: :problem_tags

  def max_score
    object.max_score
  end
end
