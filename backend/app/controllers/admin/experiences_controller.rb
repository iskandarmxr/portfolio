# ===========================================
# Admin Experiences Controller
# ===========================================
module Admin
  class ExperiencesController < BaseController
    before_action :set_experience, only: [:show, :edit, :update, :destroy]

    def index
      @experiences = Experience.ordered
    end

    def show
    end

    def new
      @experience = Experience.new
    end

    def create
      @experience = Experience.new(experience_params)
      @experience.position = Experience.maximum(:position).to_i + 1

      if @experience.save
        redirect_to admin_experiences_path, notice: "Experience created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @experience.update(experience_params)
        redirect_to admin_experiences_path, notice: "Experience updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @experience.destroy
      redirect_to admin_experiences_path, notice: "Experience deleted successfully."
    end

    def reorder
      params[:order].each_with_index do |id, index|
        Experience.where(id: id).update_all(position: index)
      end
      
      # Broadcast reorder to frontend
      ContentUpdatesChannel.broadcast_reorder("experience")
      
      head :ok
    end

    private

    def set_experience
      @experience = Experience.find(params[:id])
    end

    def experience_params
      params.require(:experience).permit(
        :company, :role, :location, :company_url, :company_logo,
        :start_date, :end_date, :description, :current,
        highlights: []
      )
    end
  end
end
