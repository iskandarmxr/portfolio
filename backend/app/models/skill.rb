# ===========================================
# Skill Model
# ===========================================
class Skill < ApplicationRecord
  include Broadcastable

  # Associations
  has_many :project_technologies, dependent: :destroy
  has_many :projects, through: :project_technologies

  # Constants
  CATEGORIES = %w[frontend backend database devops tools languages frameworks other].freeze

  # Validations
  validates :name, presence: true, uniqueness: { scope: :category }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :proficiency, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :ordered, -> { order(position: :asc) }
  scope :by_category, ->(category) { where(category: category) }

  # Class methods
  def self.grouped_by_category
    ordered.group_by(&:category)
  end
end
