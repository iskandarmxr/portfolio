# ===========================================
# Admin Base Controller
# ===========================================
module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!

    private

    def set_sidebar_counts
      @unread_messages_count = Message.unread.count
      @draft_posts_count = Post.draft.count
    end
  end
end
