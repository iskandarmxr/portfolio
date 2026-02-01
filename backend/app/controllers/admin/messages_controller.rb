# ===========================================
# Admin Messages Controller
# ===========================================
module Admin
  class MessagesController < BaseController
    before_action :set_message, only: [:show, :destroy, :mark_read, :mark_unread]

    def index
      @messages = Message.active.recent
      @messages = @messages.unread if params[:filter] == 'unread'
      @messages = @messages.archived if params[:filter] == 'archived'
    end

    def show
      @message.mark_as_read! unless @message.read?
    end

    def destroy
      @message.destroy
      redirect_to admin_messages_path, notice: "Message deleted."
    end

    def mark_read
      @message.mark_as_read!
      redirect_back fallback_location: admin_messages_path
    end

    def mark_unread
      @message.mark_as_unread!
      redirect_back fallback_location: admin_messages_path
    end

    def mark_all_read
      Message.unread.update_all(read: true)
      redirect_to admin_messages_path, notice: "All messages marked as read."
    end

    private

    def set_message
      @message = Message.find(params[:id])
    end
  end
end
