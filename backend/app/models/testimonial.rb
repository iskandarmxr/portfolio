# ===========================================
# Testimonial Model
# ===========================================
class Testimonial < ApplicationRecord
  include Broadcastable

  # Validations
  validates :author_name, presence: true
  validates :content, presence: true
  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :ordered, -> { order(position: :asc) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def author_info
    parts = [author_name]
    parts << author_title if author_title.present?
    parts << "at #{author_company}" if author_company.present?
    parts.join(', ')
  end

  def stars
    '★' * rating + '☆' * (5 - rating)
  end
end
