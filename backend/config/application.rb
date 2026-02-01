require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module Portfolio
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 7.1
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties
    config.autoload_lib(ignore: %w(assets tasks))

    # Time zone
    config.time_zone = "UTC"

    # Generators
    config.generators do |g|
      g.orm :active_record, primary_key_type: :bigint
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.stylesheets false
      g.javascripts false
      g.helper false
    end

    # API mode for fragments (but keep full Rails for admin)
    # config.api_only = false

    # Active Storage
    config.active_storage.variant_processor = :mini_magick
    
    # Default URL options for Active Storage and other URL helpers
    config.action_controller.default_url_options = {
      host: ENV.fetch('RAILS_HOST', 'localhost:8080')
    }

    # Action Cable
    config.action_cable.mount_path = "/cable"
    config.action_cable.url = ENV.fetch("ACTION_CABLE_URL", "ws://localhost:3000/cable")
    config.action_cable.allowed_request_origins = [
      ENV.fetch("FRONTEND_URL", "http://localhost"),
      /http:\/\/localhost.*/
    ]
  end
end
