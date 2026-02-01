# ===========================================
# Testimonials Fragment Controller
# ===========================================
module Fragments
  class TestimonialsController < BaseController
    def index
      @testimonials = Testimonial.ordered
    end
  end
end
