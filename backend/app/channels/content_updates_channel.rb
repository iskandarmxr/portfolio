# ===========================================
# Content Updates Channel
# Broadcasts real-time content changes to frontend
# ===========================================
class ContentUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "content_updates"
  end

  def unsubscribed
    # Cleanup when channel is unsubscribed
  end

  # Class methods for broadcasting updates
  class << self
    def broadcast_update(model_name, action, record)
      ActionCable.server.broadcast(
        "content_updates",
        {
          type: "content_update",
          model: model_name,
          action: action,
          id: record.id,
          data: serialize_record(model_name, record),
          timestamp: Time.current.iso8601
        }
      )
    end

    def broadcast_delete(model_name, record_id)
      ActionCable.server.broadcast(
        "content_updates",
        {
          type: "content_update",
          model: model_name,
          action: "destroy",
          id: record_id,
          timestamp: Time.current.iso8601
        }
      )
    end

    def broadcast_reorder(model_name)
      ActionCable.server.broadcast(
        "content_updates",
        {
          type: "content_update",
          model: model_name,
          action: "reorder",
          timestamp: Time.current.iso8601
        }
      )
    end

    # Special broadcast for settings (key-value store)
    def broadcast_settings_update(settings_hash)
      ActionCable.server.broadcast(
        "content_updates",
        {
          type: "content_update",
          model: "settings",
          action: "update",
          id: nil,
          data: settings_hash,
          timestamp: Time.current.iso8601
        }
      )
    end

    private

    def serialize_record(model_name, record)
      case model_name
      when "project"
        {
          id: record.id,
          title: record.title,
          short_description: record.short_description,
          description: record.description,
          status: record.status,
          featured: record.featured,
          category: record.category,
          gradient_start: record.gradient_start,
          gradient_end: record.gradient_end,
          image_url: record.image_url,
          live_url: record.live_url,
          github_url: record.github_url
        }
      when "post"
        {
          id: record.id,
          title: record.title,
          slug: record.slug,
          excerpt: record.excerpt,
          status: record.status,
          published_at: record.published_at&.iso8601
        }
      when "skill"
        {
          id: record.id,
          name: record.name,
          category: record.category,
          proficiency: record.proficiency,
          icon_class: record.icon_class
        }
      when "experience"
        {
          id: record.id,
          company: record.company,
          role: record.role,
          location: record.location,
          start_date: record.start_date&.iso8601,
          end_date: record.end_date&.iso8601,
          current: record.current,
          description: record.description
        }
      when "testimonial"
        {
          id: record.id,
          author_name: record.author_name,
          author_title: record.author_title,
          author_company: record.author_company,
          content: record.content,
          rating: record.rating,
          featured: record.featured
        }
      else
        { id: record.id }
      end
    end
  end
end
