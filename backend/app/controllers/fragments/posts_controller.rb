# ===========================================
# Posts Fragment Controller (Blog)
# ===========================================
module Fragments
  class PostsController < BaseController
    def index
      @posts = Post.published.recent
      @posts = @posts.limit(params[:limit].to_i) if params[:limit].present?
      @posts = @posts.offset(params[:offset].to_i) if params[:offset].present?
    end

    def show
      @post = Post.published.find_by!(slug: params[:slug])
      @post.increment_views!
      @related_posts = Post.published
                           .where.not(id: @post.id)
                           .where("tags && ARRAY[?]::text[]", @post.tags)
                           .limit(3)
    end

    def search
      query = params[:q].to_s.strip
      @posts = if query.present?
                 Post.published.search(query).recent.limit(10)
               else
                 Post.none
               end
    end
  end
end
