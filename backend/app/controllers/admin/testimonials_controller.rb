# ===========================================
# Admin Testimonials Controller
# ===========================================
module Admin
  class TestimonialsController < BaseController
    before_action :set_testimonial, only: [:show, :edit, :update, :destroy, :toggle_featured]

    def index
      @testimonials = Testimonial.ordered
    end

    def show
    end

    def new
      @testimonial = Testimonial.new
    end

    def create
      @testimonial = Testimonial.new(testimonial_params)
      @testimonial.position = Testimonial.maximum(:position).to_i + 1

      if @testimonial.save
        redirect_to admin_testimonials_path, notice: "Testimonial created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @testimonial.update(testimonial_params)
        redirect_to admin_testimonials_path, notice: "Testimonial updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @testimonial.destroy
      redirect_to admin_testimonials_path, notice: "Testimonial deleted successfully."
    end

    def toggle_featured
      @testimonial.update(featured: !@testimonial.featured)
      redirect_to admin_testimonials_path, notice: "Testimonial #{@testimonial.featured? ? 'featured' : 'unfeatured'}."
    end

    def reorder
      params[:order].each_with_index do |id, index|
        Testimonial.where(id: id).update_all(position: index)
      end
      
      # Broadcast reorder to frontend
      ContentUpdatesChannel.broadcast_reorder("testimonial")
      
      head :ok
    end

    private

    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    def testimonial_params
      params.require(:testimonial).permit(
        :author_name, :author_title, :author_company, :author_image,
        :content, :rating, :featured
      )
    end
  end
end
