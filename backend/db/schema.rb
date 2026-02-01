# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_01_31_150000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.text "email", null: false
    t.text "password_digest", null: false
    t.text "name", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "experiences", force: :cascade do |t|
    t.text "company", null: false
    t.text "role", null: false
    t.text "location"
    t.text "company_url"
    t.text "company_logo"
    t.date "start_date", null: false
    t.date "end_date"
    t.text "description"
    t.text "highlights", default: [], array: true
    t.boolean "current", default: false, null: false
    t.integer "position", default: 0, null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["current"], name: "index_experiences_on_current"
    t.index ["position"], name: "index_experiences_on_position"
    t.index ["start_date"], name: "index_experiences_on_start_date"
  end

  create_table "messages", force: :cascade do |t|
    t.text "name", null: false
    t.text "email", null: false
    t.text "subject"
    t.text "content", null: false
    t.text "project_type"
    t.boolean "read", default: false, null: false
    t.boolean "archived", default: false, null: false
    t.text "ip_address"
    t.text "user_agent"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["archived"], name: "index_messages_on_archived"
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["read"], name: "index_messages_on_read"
  end

  create_table "posts", force: :cascade do |t|
    t.text "title", null: false
    t.text "slug", null: false
    t.text "content"
    t.text "excerpt"
    t.text "cover_image"
    t.text "status", default: "draft", null: false
    t.text "tags", default: [], array: true
    t.timestamptz "published_at"
    t.bigint "view_count", default: 0, null: false
    t.integer "reading_time_minutes"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["status"], name: "index_posts_on_status"
    t.index ["tags"], name: "index_posts_on_tags", using: :gin
    t.check_constraint "status = ANY (ARRAY['draft'::text, 'published'::text, 'archived'::text])", name: "posts_status_check"
  end

  create_table "project_technologies", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "skill_id", null: false
    t.timestamptz "created_at", null: false
    t.index ["project_id", "skill_id"], name: "index_project_technologies_on_project_id_and_skill_id", unique: true
    t.index ["project_id"], name: "index_project_technologies_on_project_id"
    t.index ["skill_id"], name: "index_project_technologies_on_skill_id"
  end

  create_table "projects", force: :cascade do |t|
    t.text "title", null: false
    t.text "description"
    t.text "short_description"
    t.text "image_url"
    t.text "live_url"
    t.text "github_url"
    t.text "video_url"
    t.text "status", default: "draft", null: false
    t.integer "position", default: 0, null: false
    t.boolean "featured", default: false, null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "project_type", default: "Web App"
    t.text "completion_quarter"
    t.text "gradient_color", default: "purple"
    t.jsonb "key_features", default: []
    t.text "gallery_images", default: [], array: true
    t.string "category", default: "Web App"
    t.string "gradient_start", default: "#8B5CF6"
    t.string "gradient_end", default: "#6366F1"
    t.index ["featured"], name: "index_projects_on_featured"
    t.index ["position"], name: "index_projects_on_position"
    t.index ["project_type"], name: "index_projects_on_project_type"
    t.index ["status"], name: "index_projects_on_status"
    t.check_constraint "status = ANY (ARRAY['draft'::text, 'published'::text, 'archived'::text])", name: "projects_status_check"
  end

  create_table "site_settings", force: :cascade do |t|
    t.text "key", null: false
    t.text "value"
    t.text "value_type", default: "string", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["key"], name: "index_site_settings_on_key", unique: true
    t.check_constraint "value_type = ANY (ARRAY['string'::text, 'text'::text, 'integer'::text, 'boolean'::text, 'json'::text])", name: "site_settings_value_type_check"
  end

  create_table "skills", force: :cascade do |t|
    t.text "name", null: false
    t.text "category", null: false
    t.integer "proficiency", default: 80, null: false
    t.text "icon_class"
    t.integer "position", default: 0, null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["category"], name: "index_skills_on_category"
    t.index ["name", "category"], name: "index_skills_on_name_and_category", unique: true
    t.index ["position"], name: "index_skills_on_position"
    t.check_constraint "category = ANY (ARRAY['frontend'::text, 'backend'::text, 'database'::text, 'devops'::text, 'tools'::text, 'languages'::text, 'frameworks'::text, 'other'::text])", name: "skills_category_check"
    t.check_constraint "proficiency >= 0 AND proficiency <= 100", name: "skills_proficiency_check"
  end

  create_table "testimonials", force: :cascade do |t|
    t.text "author_name", null: false
    t.text "author_title"
    t.text "author_company"
    t.text "author_image"
    t.text "content", null: false
    t.integer "rating", default: 5
    t.boolean "featured", default: false, null: false
    t.integer "position", default: 0, null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["featured"], name: "index_testimonials_on_featured"
    t.index ["position"], name: "index_testimonials_on_position"
    t.check_constraint "rating >= 1 AND rating <= 5", name: "testimonials_rating_check"
  end

  create_table "visitors", force: :cascade do |t|
    t.text "session_id", null: false
    t.text "ip_address"
    t.text "user_agent"
    t.text "page_visited"
    t.text "referrer"
    t.text "country"
    t.text "city"
    t.timestamptz "created_at", null: false
    t.index ["created_at"], name: "index_visitors_on_created_at"
    t.index ["page_visited"], name: "index_visitors_on_page_visited"
    t.index ["session_id"], name: "index_visitors_on_session_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "project_technologies", "projects"
  add_foreign_key "project_technologies", "skills"
end
