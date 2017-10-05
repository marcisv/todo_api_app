class TaskSerializer < ActiveModel::Serializer
  attributes :title
  has_many :tags
end
