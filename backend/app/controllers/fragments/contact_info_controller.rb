# ===========================================
# Contact Info Fragment Controller
# Returns dynamic contact information from settings
# ===========================================
module Fragments
  class ContactInfoController < BaseController
    def show
      @settings = {
        name: SiteSetting.get('owner_name', 'Developer'),
        email: SiteSetting.get('owner_email', 'hello@example.com'),
        location: SiteSetting.get('owner_location', ''),
        github: SiteSetting.get('github_url', ''),
        linkedin: SiteSetting.get('linkedin_url', ''),
        twitter: SiteSetting.get('twitter_url', ''),
        # Contact page content
        heading: SiteSetting.get('contact_heading', "Let's build something amazing together"),
        description: SiteSetting.get('contact_description', 'Whether you have a project idea, a question, or just want to say hello, feel free to reach out.'),
        response_time: SiteSetting.get('contact_response_time', 'I typically respond within 24 hours.')
      }
    end
  end
end
