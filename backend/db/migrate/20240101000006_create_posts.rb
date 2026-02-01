# ===========================================
# Posts Table (Blog)
# ===========================================
class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.text :title, null: false
      t.text :slug, null: false
      t.text :content
      t.text :excerpt
      t.text :cover_image
      t.text :status, null: false, default: 'draft'
      t.text :tags, array: true, default: []
      t.timestamptz :published_at
      t.bigint :view_count, null: false, default: 0
      t.integer :reading_time_minutes

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    # CHECK constraint for status enum
    execute <<-SQL
      ALTER TABLE posts
      ADD CONSTRAINT posts_status_check
      CHECK (status IN ('draft', 'published', 'archived'));
    SQL

    add_index :posts, :slug, unique: true
    add_index :posts, :status
    add_index :posts, :published_at
    add_index :posts, :tags, using: :gin
  end
end
