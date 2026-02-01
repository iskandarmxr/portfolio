# ===========================================
# Projects Table
# ===========================================
class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.text :title, null: false
      t.text :description
      t.text :short_description
      t.text :image_url
      t.text :live_url
      t.text :github_url
      t.text :video_url
      t.text :status, null: false, default: 'draft'
      t.integer :position, null: false, default: 0
      t.boolean :featured, null: false, default: false

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    # CHECK constraint for status enum
    execute <<-SQL
      ALTER TABLE projects
      ADD CONSTRAINT projects_status_check
      CHECK (status IN ('draft', 'published', 'archived'));
    SQL

    add_index :projects, :status
    add_index :projects, :featured
    add_index :projects, :position
  end
end
