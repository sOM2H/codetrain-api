class ProblemTagSerializer < ActiveModel::Serializer
  attributes :id, :name

  def name
    object.tag.name
  end

  def id
    object.tag.id
  end
end
