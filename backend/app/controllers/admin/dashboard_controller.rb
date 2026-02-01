# ===========================================
# Admin Dashboard Controller
# ===========================================
module Admin
  class DashboardController < BaseController
    def index
      # Stats
      @stats = {
        unread_messages: Message.unread.count,
        total_visitors: Visitor.unique_this_month,
        visitors_today: Visitor.unique_today,
        published_posts: Post.published.count,
        published_projects: Project.published.count
      }

      # Recent messages
      @recent_messages = Message.recent.limit(5)

      # Recent visitors (page views)
      @page_views = Visitor.top_pages(5)

      # Activity (recent items)
      @recent_posts = Post.recent.limit(3)
      @recent_projects = Project.recent.limit(3)
    end
  end
end
