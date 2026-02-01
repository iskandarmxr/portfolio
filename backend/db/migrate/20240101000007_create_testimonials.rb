# ===========================================
# Testimonials Table
# ===========================================
class CreateTestimonials < ActiveRecord::Migration[7.1]
  def change
    create_table :testimonials do |t|
      t.text :author_name, null: false
      t.text :author_title
      t.text :author_company
      t.text :author_image
      t.text :content, null: false
      t.integer :rating, default: 5
      t.boolean :featured, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    # CHECK constraint for rating (1-5)
    execute <<-SQL
      ALTER TABLE testimonials
      ADD CONSTRAINT testimonials_rating_check
      CHECK (rating >= 1 AND rating <= 5);
    SQL

    add_index :testimonials, :featured
    add_index :testimonials, :position
  end
end
