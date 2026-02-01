# ===========================================
# Add category and gradient colors to projects
# ===========================================
class AddCategoryAndGradientToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :category, :string, default: 'Web App'
    add_column :projects, :gradient_start, :string, default: '#8B5CF6'
    add_column :projects, :gradient_end, :string, default: '#6366F1'
  end
end
