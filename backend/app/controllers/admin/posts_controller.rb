# ===========================================
# Admin Posts Controller (Blog)
# ===========================================
module Admin
  class PostsController < BaseController
    before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

    def index
      @posts = Post.recent
      @posts = @posts.where(status: params[:status]) if params[:status].present?
    end

    def show
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to admin_posts_path, notice: "Post created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: "Post updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Post deleted successfully."
    end

    def publish
      @post.publish!
      redirect_to admin_posts_path, notice: "Post published successfully."
    end

    def unpublish
      @post.unpublish!
      redirect_to admin_posts_path, notice: "Post unpublished."
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(
        :title, :slug, :content, :excerpt, :cover_image,
        :status, :cover, tags: []
      )
    end
  end
end
