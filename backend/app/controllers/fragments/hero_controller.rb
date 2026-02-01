# ===========================================
# Hero Fragment Controller
# ===========================================
module Fragments
  class HeroController < BaseController
    def show
      @settings = {
        name: SiteSetting.get('owner_name', 'Developer'),
        tagline: SiteSetting.get('site_tagline', 'Full-Stack Developer'),
        bio: SiteSetting.get('owner_bio', 'I build things for the web.'),
        available: SiteSetting.get('available_for_work', true)
      }
      @visitor_count = Visitor.unique_today
      @project_count = Project.published.count
    end
  end
end
