# ===========================================
# Visitors Channel
# Real-time visitor count updates
# ===========================================
class VisitorsChannel < ApplicationCable::Channel
  @@visitor_count = 0

  def subscribed
    stream_from "visitors_channel"
    
    @@visitor_count += 1
    broadcast_count
  end

  def unsubscribed
    @@visitor_count -= 1 if @@visitor_count > 0
    broadcast_count
  end

  private

  def broadcast_count
    ActionCable.server.broadcast(
      "visitors_channel",
      {
        type: "visitor_count",
        count: @@visitor_count
      }
    )
  end
end
