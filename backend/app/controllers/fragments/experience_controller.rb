# ===========================================
# Experience Fragment Controller
# ===========================================
module Fragments
  class ExperienceController < BaseController
    def index
      @experiences = Experience.ordered
    end
  end
end
