# ===========================================
# Skills Table
# ===========================================
class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.text :name, null: false
      t.text :category, null: false
      t.integer :proficiency, null: false, default: 80
      t.text :icon_class
      t.integer :position, null: false, default: 0

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    # CHECK constraint for category enum
    execute <<-SQL
      ALTER TABLE skills
      ADD CONSTRAINT skills_category_check
      CHECK (category IN ('frontend', 'backend', 'database', 'devops', 'tools', 'languages', 'frameworks', 'other'));
    SQL

    # CHECK constraint for proficiency (0-100)
    execute <<-SQL
      ALTER TABLE skills
      ADD CONSTRAINT skills_proficiency_check
      CHECK (proficiency >= 0 AND proficiency <= 100);
    SQL

    add_index :skills, :category
    add_index :skills, :position
    add_index :skills, [:name, :category], unique: true
  end
end
