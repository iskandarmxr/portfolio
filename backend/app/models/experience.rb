# ===========================================
# Experience Model (Work History)
# ===========================================
class Experience < ApplicationRecord
  include Broadcastable

  # Validations
  validates :company, presence: true
  validates :role, presence: true
  validates :start_date, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :end_date_after_start_date

  # Scopes
  scope :ordered, -> { order(position: :asc) }
  scope :chronological, -> { order(start_date: :desc) }
  scope :current_positions, -> { where(current: true) }

  # Methods
  def duration
    end_date_for_calculation = current? ? Date.current : end_date
    return nil unless start_date && end_date_for_calculation

    months = (end_date_for_calculation.year * 12 + end_date_for_calculation.month) -
             (start_date.year * 12 + start_date.month)
    years = months / 12
    remaining_months = months % 12

    parts = []
    parts << "#{years} year#{'s' if years != 1}" if years > 0
    parts << "#{remaining_months} month#{'s' if remaining_months != 1}" if remaining_months > 0
    parts.join(', ')
  end

  def date_range
    if current?
      "#{start_date.strftime('%b %Y')} - Present"
    elsif end_date
      "#{start_date.strftime('%b %Y')} - #{end_date.strftime('%b %Y')}"
    else
      start_date.strftime('%b %Y')
    end
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
