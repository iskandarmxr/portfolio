# ===========================================
# Post Model (Blog)
# ===========================================
class Post < ApplicationRecord
  include Broadcastable

  # Associations
  has_one_attached :cover
  has_rich_text :rich_content

  # Constants
  STATUSES = %w[draft published archived].freeze

  # Validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/ }
  validates :status, presence: true, inclusion: { in: STATUSES }

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_save :calculate_reading_time

  # Scopes
  scope :published, -> { where(status: 'published').where.not(published_at: nil) }
  scope :draft, -> { where(status: 'draft') }
  scope :archived, -> { where(status: 'archived') }
  scope :recent, -> { order(published_at: :desc) }
  scope :popular, -> { order(view_count: :desc) }
  scope :with_tag, ->(tag) { where("? = ANY(tags)", tag) }
  scope :search, ->(query) {
    where("title ILIKE :q OR content ILIKE :q OR excerpt ILIKE :q", q: "%#{query}%")
  }

  # Methods
  def published?
    status == 'published' && published_at.present?
  end

  def draft?
    status == 'draft'
  end

  def publish!
    update!(status: 'published', published_at: Time.current)
  end

  def unpublish!
    update!(status: 'draft', published_at: nil)
  end

  def increment_views!
    increment!(:view_count)
  end

  def formatted_date
    published_at&.strftime('%B %d, %Y')
  end

  private

  def generate_slug
    self.slug = title.parameterize
  end

  def calculate_reading_time
    return unless content.present?

    words_per_minute = 200
    word_count = content.split.size
    self.reading_time_minutes = (word_count.to_f / words_per_minute).ceil
  end
end
