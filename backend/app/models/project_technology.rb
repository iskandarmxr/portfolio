# ===========================================
# Project Technology Join Model
# ===========================================
class ProjectTechnology < ApplicationRecord
  # Associations
  belongs_to :project
  belongs_to :skill

  # Validations
  validates :project_id, uniqueness: { scope: :skill_id }
end
