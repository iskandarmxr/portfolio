# ===========================================
# Site Setting Model (Key-Value Store)
# ===========================================
class SiteSetting < ApplicationRecord
  # Constants
  VALUE_TYPES = %w[string text integer boolean json].freeze

  # Validations
  validates :key, presence: true, uniqueness: true
  validates :value_type, presence: true, inclusion: { in: VALUE_TYPES }

  # Class methods
  def self.get(key, default = nil)
    setting = find_by(key: key)
    return default unless setting

    setting.typed_value
  end

  def self.set(key, value, value_type = 'string')
    setting = find_or_initialize_by(key: key)
    setting.value = value.to_s
    setting.value_type = value_type
    setting.save!
    setting
  end

  # Default settings
  DEFAULTS = {
    'site_name' => { value: 'My Portfolio', type: 'string' },
    'site_tagline' => { value: 'Full-Stack Developer', type: 'string' },
    'owner_name' => { value: 'John Doe', type: 'string' },
    'owner_email' => { value: 'hello@example.com', type: 'string' },
    'owner_bio' => { value: 'I build things for the web.', type: 'text' },
    'owner_location' => { value: 'San Francisco, CA', type: 'string' },
    'github_url' => { value: '', type: 'string' },
    'linkedin_url' => { value: '', type: 'string' },
    'twitter_url' => { value: '', type: 'string' },
    'available_for_work' => { value: 'true', type: 'boolean' },
    # Contact page content
    'contact_heading' => { value: "Let's build something amazing together", type: 'string' },
    'contact_description' => { value: "Whether you have a project idea, a question, or just want to say hello, feel free to reach out.", type: 'text' },
    'contact_response_time' => { value: 'I typically respond within 24 hours.', type: 'string' }
  }.freeze

  def self.seed_defaults!
    DEFAULTS.each do |key, config|
      find_or_create_by!(key: key) do |setting|
        setting.value = config[:value]
        setting.value_type = config[:type]
      end
    end
  end

  # Instance methods
  def typed_value
    case value_type
    when 'integer'
      value.to_i
    when 'boolean'
      value == 'true'
    when 'json'
      JSON.parse(value) rescue {}
    else
      value
    end
  end
end
