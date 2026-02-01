# ===========================================
# Messages Table (Contact Form)
# ===========================================
class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :name, null: false
      t.text :email, null: false
      t.text :subject
      t.text :content, null: false
      t.text :project_type
      t.boolean :read, null: false, default: false
      t.boolean :archived, null: false, default: false
      t.text :ip_address
      t.text :user_agent

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    add_index :messages, :read
    add_index :messages, :archived
    add_index :messages, :created_at
  end
end
