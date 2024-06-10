class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :complexity

  has_many :tags, through: :problem_tags
end
