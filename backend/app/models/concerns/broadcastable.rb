# ===========================================
# Broadcastable Concern
# Adds real-time broadcast callbacks to models
# ===========================================
module Broadcastable
  extend ActiveSupport::Concern

  included do
    after_commit :broadcast_create, on: :create
    after_commit :broadcast_update, on: :update
    after_commit :broadcast_destroy, on: :destroy
  end

  private

  def broadcast_create
    return unless should_broadcast?
    ContentUpdatesChannel.broadcast_update(model_name_for_broadcast, "create", self)
  end

  def broadcast_update
    return unless should_broadcast?
    ContentUpdatesChannel.broadcast_update(model_name_for_broadcast, "update", self)
  end

  def broadcast_destroy
    ContentUpdatesChannel.broadcast_delete(model_name_for_broadcast, id)
  end

  def model_name_for_broadcast
    self.class.name.underscore
  end

  # Override in models to conditionally broadcast
  # e.g., only broadcast published content
  def should_broadcast?
    true
  end
end
