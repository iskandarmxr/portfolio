# ===========================================
# Visitors Table (Analytics)
# ===========================================
class CreateVisitors < ActiveRecord::Migration[7.1]
  def change
    create_table :visitors do |t|
      t.text :session_id, null: false
      t.text :ip_address
      t.text :user_agent
      t.text :page_visited
      t.text :referrer
      t.text :country
      t.text :city

      t.timestamptz :created_at, null: false
    end

    add_index :visitors, :session_id
    add_index :visitors, :created_at
    add_index :visitors, :page_visited
  end
end
