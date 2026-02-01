# ===========================================
# Message Model (Contact Form)
# ===========================================
class Message < ApplicationRecord
  # Constants
  PROJECT_TYPES = %w[freelance contract full-time collaboration other].freeze

  # Validations
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :content, presence: true
  validates :project_type, inclusion: { in: PROJECT_TYPES }, allow_blank: true

  # Scopes
  scope :unread, -> { where(read: false) }
  scope :read_messages, -> { where(read: true) }
  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods
  def self.unread_count
    unread.count
  end

  # Methods
  def mark_as_read!
    update!(read: true)
  end

  def mark_as_unread!
    update!(read: false)
  end

  def archive!
    update!(archived: true)
  end

  def unarchive!
    update!(archived: false)
  end

  def preview
    content.truncate(100)
  end

  def formatted_date
    created_at.strftime('%B %d, %Y at %I:%M %p')
  end

  def short_date
    if created_at.today?
      created_at.strftime('%I:%M %p')
    elsif created_at.year == Date.current.year
      created_at.strftime('%b %d')
    else
      created_at.strftime('%b %d, %Y')
    end
  end
end
