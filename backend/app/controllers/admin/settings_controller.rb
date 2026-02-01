# ===========================================
# Admin Settings Controller
# ===========================================
module Admin
  class SettingsController < BaseController
    def show
      load_settings
    end

    def update
      settings_params.each do |key, value|
        value_type = determine_value_type(key)
        SiteSetting.set(key, value, value_type)
      end

      # Broadcast settings update to frontend
      broadcast_settings_update

      redirect_to admin_settings_path, notice: "Settings updated successfully."
    end

    private

    def load_settings
      @settings = {}
      SiteSetting::DEFAULTS.keys.each do |key|
        @settings[key] = SiteSetting.get(key)
      end
    end

    def settings_params
      params.require(:settings).permit(
        :site_name, :site_tagline, :owner_name, :owner_email,
        :owner_bio, :owner_location, :github_url, :linkedin_url,
        :twitter_url, :available_for_work,
        :contact_heading, :contact_description, :contact_response_time
      )
    end

    def determine_value_type(key)
      case key
      when 'available_for_work'
        'boolean'
      when 'owner_bio', 'contact_description'
        'text'
      else
        'string'
      end
    end

    def broadcast_settings_update
      # Gather all current settings for broadcast
      settings_hash = {}
      SiteSetting::DEFAULTS.keys.each do |key|
        settings_hash[key] = SiteSetting.get(key)
      end
      
      ContentUpdatesChannel.broadcast_settings_update(settings_hash)
    end
  end
end
