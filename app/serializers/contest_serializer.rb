class ContestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start_time, :end_time, :unlimited

  belongs_to :organization

  def unlimited
    object.unlimited?
  end
end