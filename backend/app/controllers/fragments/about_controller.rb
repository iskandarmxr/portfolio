# ===========================================
# About Fragment Controller
# ===========================================
module Fragments
  class AboutController < BaseController
    def show
      @settings = {
        name: SiteSetting.get('owner_name', 'Developer'),
        bio: SiteSetting.get('owner_bio', 'I build things for the web.'),
        location: SiteSetting.get('owner_location', ''),
        email: SiteSetting.get('owner_email', ''),
        github: SiteSetting.get('github_url', ''),
        linkedin: SiteSetting.get('linkedin_url', ''),
        twitter: SiteSetting.get('twitter_url', '')
      }
      @skills = Skill.grouped_by_category
      @experience_years = calculate_experience_years
      @project_count = Project.published.count
      @client_count = Experience.distinct.count(:company)
    end

    private

    def calculate_experience_years
      first_experience = Experience.order(start_date: :asc).first
      return 0 unless first_experience

      ((Date.current - first_experience.start_date) / 365).to_i
    end
  end
end
