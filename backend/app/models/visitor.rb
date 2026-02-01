# ===========================================
# Visitor Model (Analytics)
# ===========================================
class Visitor < ApplicationRecord
  # Validations
  validates :session_id, presence: true

  # Scopes
  scope :today, -> { where("created_at >= ?", Time.current.beginning_of_day) }
  scope :this_week, -> { where("created_at >= ?", 1.week.ago) }
  scope :this_month, -> { where("created_at >= ?", 1.month.ago) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods
  def self.unique_today
    today.distinct.count(:session_id)
  end

  def self.unique_this_week
    this_week.distinct.count(:session_id)
  end

  def self.unique_this_month
    this_month.distinct.count(:session_id)
  end

  def self.page_views_today
    today.count
  end

  def self.top_pages(limit = 10)
    group(:page_visited).count.sort_by { |_, v| -v }.first(limit).to_h
  end

  def self.top_referrers(limit = 10)
    where.not(referrer: [nil, '']).group(:referrer).count.sort_by { |_, v| -v }.first(limit).to_h
  end
end
