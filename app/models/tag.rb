class Tag < ApplicationRecord

  validates :title, presence: true, uniqueness: true

  scope :by_title, ->(title) { where('title LIKE ?', "%#{title}%") }

end
