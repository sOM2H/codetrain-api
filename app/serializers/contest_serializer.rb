class ContestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description,
             :start_time, :end_time, :unlimited,
             :average_complexity, :tags

  belongs_to :organization

  def unlimited
    object.unlimited?
  end

  def average_complexity
    object.average_complexity
  end

  def tags
    object.tags
  end
end