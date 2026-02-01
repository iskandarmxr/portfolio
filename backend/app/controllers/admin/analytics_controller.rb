# ===========================================
# Admin Analytics Controller
# ===========================================
module Admin
  class AnalyticsController < BaseController
    def index
      @stats = {
        unique_visitors_today: Visitor.unique_today,
        unique_visitors_week: Visitor.unique_this_week,
        unique_visitors_month: Visitor.unique_this_month,
        page_views_today: Visitor.page_views_today
      }

      @top_pages = Visitor.top_pages(10)
      @top_referrers = Visitor.top_referrers(10)

      # Daily visitors for the last 30 days
      @daily_visitors = Visitor
        .where("created_at >= ?", 30.days.ago)
        .group("DATE(created_at)")
        .distinct
        .count(:session_id)
        .sort
        .to_h
    end
  end
end
