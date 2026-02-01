# ===========================================
# Projects Fragment Controller
# ===========================================
module Fragments
  class ProjectsController < BaseController
    def index
      @projects = Project.published.includes(:technologies).ordered
    end

    def featured
      @projects = Project.published.featured.includes(:technologies).ordered.limit(6)
      render :index
    end

    def show
      @project = Project.find(params[:id])
    end

    def filter
      technology = params[:technology]
      @projects = Project.published
                         .joins(:technologies)
                         .where(skills: { name: technology })
                         .includes(:technologies)
                         .distinct
                         .ordered
      render :index
    end
  end
end
