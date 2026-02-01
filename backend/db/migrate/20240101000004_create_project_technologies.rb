# ===========================================
# Project Technologies Join Table
# ===========================================
class CreateProjectTechnologies < ActiveRecord::Migration[7.1]
  def change
    create_table :project_technologies do |t|
      t.references :project, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamptz :created_at, null: false
    end

    # PostgreSQL does NOT auto-index FK columns - add manually
    # Note: t.references already creates indexes, but we ensure uniqueness
    add_index :project_technologies, [:project_id, :skill_id], unique: true
  end
end
