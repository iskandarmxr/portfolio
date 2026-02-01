# ===========================================
# Project Model
# ===========================================
class Project < ApplicationRecord
  include Broadcastable

  # Associations
  has_many :project_technologies, dependent: :destroy
  has_many :technologies, through: :project_technologies, source: :skill
  has_one_attached :image
  has_one_attached :video

  # Constants
  STATUSES = %w[draft published archived].freeze
  CATEGORIES = ['Desktop App', 'Mobile App', 'Web App', 'API', 'Library', 'Game', 'Tool', 'Other'].freeze
  
  # Default gradient colors for project cards
  GRADIENT_PRESETS = {
    'orange' => { start: '#F97316', end: '#EA580C' },
    'green' => { start: '#22C55E', end: '#16A34A' },
    'purple' => { start: '#8B5CF6', end: '#7C3AED' },
    'blue' => { start: '#3B82F6', end: '#2563EB' },
    'pink' => { start: '#EC4899', end: '#DB2777' },
    'cyan' => { start: '#06B6D4', end: '#0891B2' },
    'red' => { start: '#EF4444', end: '#DC2626' },
    'yellow' => { start: '#EAB308', end: '#CA8A04' }
  }.freeze

  # Validations
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :published, -> { where(status: 'published') }
  scope :draft, -> { where(status: 'draft') }
  scope :archived, -> { where(status: 'archived') }
  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(position: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def published?
    status == 'published'
  end

  def draft?
    status == 'draft'
  end

  def publish!
    update!(status: 'published')
  end

  def archive!
    update!(status: 'archived')
  end

  def technology_names
    technologies.pluck(:name)
  end
end
