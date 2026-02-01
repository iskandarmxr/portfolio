# ===========================================
# Admin Skills Controller
# ===========================================
module Admin
  class SkillsController < BaseController
    before_action :set_skill, only: [:show, :edit, :update, :destroy]

    def index
      @skills = Skill.ordered
      @skills_by_category = @skills.group_by(&:category)
    end

    def show
    end

    def new
      @skill = Skill.new
    end

    def create
      @skill = Skill.new(skill_params)
      @skill.position = Skill.where(category: @skill.category).maximum(:position).to_i + 1

      if @skill.save
        redirect_to admin_skills_path, notice: "Skill created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @skill.update(skill_params)
        redirect_to admin_skills_path, notice: "Skill updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @skill.destroy
      redirect_to admin_skills_path, notice: "Skill deleted successfully."
    end

    def reorder
      params[:order].each_with_index do |id, index|
        Skill.where(id: id).update_all(position: index)
      end
      
      # Broadcast reorder to frontend
      ContentUpdatesChannel.broadcast_reorder("skill")
      
      head :ok
    end

    private

    def set_skill
      @skill = Skill.find(params[:id])
    end

    def skill_params
      params.require(:skill).permit(:name, :category, :proficiency, :icon_class)
    end
  end
end
