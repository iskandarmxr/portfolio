# ===========================================
# Skills Fragment Controller
# ===========================================
module Fragments
  class SkillsController < BaseController
    def index
      @skills_by_category = Skill.grouped_by_category
    end

    def category
      @category = params[:category]
      @skills = Skill.by_category(@category).ordered
    end
  end
end
