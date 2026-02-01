# ===========================================
# Site Settings Table (Key-Value Store)
# ===========================================
class CreateSiteSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :site_settings do |t|
      t.text :key, null: false
      t.text :value
      t.text :value_type, null: false, default: 'string'

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    # CHECK constraint for value_type enum
    execute <<-SQL
      ALTER TABLE site_settings
      ADD CONSTRAINT site_settings_value_type_check
      CHECK (value_type IN ('string', 'text', 'integer', 'boolean', 'json'));
    SQL

    add_index :site_settings, :key, unique: true
  end
end
