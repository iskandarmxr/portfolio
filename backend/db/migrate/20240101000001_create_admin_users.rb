# ===========================================
# Admin Users Table
# ===========================================
class CreateAdminUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_users do |t|
      t.text :email, null: false
      t.text :password_digest, null: false
      t.text :name, null: false

      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end

    add_index :admin_users, :email, unique: true
  end
end
