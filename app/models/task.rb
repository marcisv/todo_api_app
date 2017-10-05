class Task < ApplicationRecord

  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  validates :title, presence: true

  accepts_nested_attributes_for :task_tags

  def tags=(tags)
    if tags.all? { |tag| tag.is_a? String }
      set_tags_from_titles(tags)
    else
      super
    end
  end

  private

  def set_tags_from_titles(tag_titles)
    task_tags.each { |tt| tt.mark_for_destruction unless tag_titles.include?(tt.title) }
    current_tag_titles = task_tags.map(&:title)
    new_tag_titles = tag_titles.select { |tag_title| current_tag_titles.exclude?(tag_title) }
    self.task_tags_attributes = new_tag_titles.map do |new_title|
      tag = Tag.find_by(title: new_title)
      tag ? {tag_id: tag.id} : {tag_attributes: {title: new_title}}
    end
  end

end
