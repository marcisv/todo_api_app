class TaskTag < ApplicationRecord
  belongs_to :task
  belongs_to :tag

  accepts_nested_attributes_for :tag

  delegate :title, to: :tag

end
