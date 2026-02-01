# ===========================================
# Experiences Table (Work History)
# ===========================================
class CreateExperiences < ActiveRecord::Migration[7.1]
  def change
    create_table :experiences do |t|
      t.text :company, null: false
      t.text :role, null: false
      t.text :location
      t.text :company_url
      t.text :company_logo
      t.date :start_date, null: false
      t.date :end_date
      t.text :description
      t.text :highlights, array: true, default: []
      t.boolean :current, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    add_index :experiences, :current
    add_index :experiences, :position
    add_index :experiences, :start_date
  end
end
