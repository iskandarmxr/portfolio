# ===========================================
# Contacts Fragment Controller
# ===========================================
module Fragments
  class ContactsController < BaseController
    def create
      @message = Message.new(message_params)
      @message.ip_address = request.remote_ip
      @message.user_agent = request.user_agent

      if @message.save
        # Broadcast notification to admin via ActionCable
        ActionCable.server.broadcast(
          "notifications_channel",
          {
            type: "new_message",
            message: {
              id: @message.id,
              name: @message.name,
              preview: @message.preview,
              created_at: @message.short_date
            }
          }
        )

        render :success
      else
        @errors = @message.errors
        render :error, status: :unprocessable_entity
      end
    end

    def success
      # Success message fragment
    end

    def error
      @errors = params[:errors] || []
    end

    private

    def message_params
      params.permit(:name, :email, :subject, :content, :project_type)
    end
  end
end
