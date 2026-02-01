# ===========================================
# Notifications Channel
# Admin notifications for new messages, etc.
# ===========================================
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel"
  end

  def unsubscribed
    # Cleanup
  end

  # Broadcast a new message notification
  def self.notify_new_message(message)
    ActionCable.server.broadcast(
      "notifications_channel",
      {
        type: "new_message",
        message: {
          id: message.id,
          name: message.name,
          preview: message.preview,
          created_at: message.short_date
        }
      }
    )
  end

  # Broadcast a new visitor notification
  def self.notify_new_visitor(visitor)
    ActionCable.server.broadcast(
      "notifications_channel",
      {
        type: "new_visitor",
        visitor: {
          page: visitor.page_visited,
          referrer: visitor.referrer
        }
      }
    )
  end
end
