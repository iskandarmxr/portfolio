# ===========================================
# Admin Projects Controller
# ===========================================
module Admin
  class ProjectsController < BaseController
    before_action :set_project, only: [:show, :edit, :update, :destroy, :toggle_featured, :update_position]

    def index
      @projects = Project.includes(:technologies).ordered
      @projects = @projects.where(status: params[:status]) if params[:status].present?
    end

    def show
    end

    def new
      @project = Project.new
      @skills = Skill.ordered
    end

    def create
      @project = Project.new(project_params)
      @project.position = Project.maximum(:position).to_i + 1

      if @project.save
        update_technologies
        redirect_to admin_projects_path, notice: "Project created successfully."
      else
        @skills = Skill.ordered
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @skills = Skill.ordered
    end

    def update
      if @project.update(project_params)
        update_technologies
        redirect_to admin_projects_path, notice: "Project updated successfully."
      else
        @skills = Skill.ordered
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @project.destroy
      redirect_to admin_projects_path, notice: "Project deleted successfully."
    end

    def toggle_featured
      @project.update(featured: !@project.featured)
      redirect_to admin_projects_path, notice: "Project #{@project.featured? ? 'featured' : 'unfeatured'}."
    end

    def update_position
      @project.update(position: params[:position].to_i)
      head :ok
    end

    def reorder
      params[:order].each_with_index do |id, index|
        Project.where(id: id).update_all(position: index)
      end
      
      # Broadcast reorder to frontend
      ContentUpdatesChannel.broadcast_reorder("project")
      
      head :ok
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(
        :title, :description, :short_description,
        :image_url, :live_url, :github_url, :video_url,
        :status, :featured, :image, :video,
        :category, :gradient_start, :gradient_end
      )
    end

    def update_technologies
      technology_ids = params[:technology_ids]&.reject(&:blank?) || []
      @project.technology_ids = technology_ids
    end
  end
end
