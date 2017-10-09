class Task < ApplicationRecord

  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  validates :title, presence: true

  accepts_nested_attributes_for :task_tags, allow_destroy: true

  def tags=(tags_or_tag_titles)
    if tags_or_tag_titles.all? { |tag| tag.is_a? String }
      set_tags_from_titles(tags_or_tag_titles)
    else
      super
    end
  end

  private

  def set_tags_from_titles(tag_titles)
    task_tags_with_tags = task_tags.includes(:tag)
    current_tag_titles = task_tags_with_tags.map(&:title)
    new_tag_titles = tag_titles.select { |tag_title| current_tag_titles.exclude?(tag_title) }
    task_tags_attrs = new_tag_titles.map do |new_title|
      tag = Tag.find_by(title: new_title)
      tag ? {tag_id: tag.id} : {tag_attributes: {title: new_title}}
    end
    task_tags_with_tags.each do |task_tag|
      unless tag_titles.include?(task_tag.title)
        task_tags_attrs << {id: task_tag.id, _destroy: true}
      end
    end
    self.task_tags_attributes = task_tags_attrs
  end

end
