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

ActiveRecord::Schema[8.0].define(version: 2026_09_25_000003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "business_hours", force: :cascade do |t|
    t.integer "day_of_week"
    t.date "specific_date"
    t.string "open_time"
    t.string "close_time"
    t.boolean "closed", default: false, null: false
    t.string "reason"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_of_week"], name: "index_business_hours_on_day_of_week", unique: true, where: "(specific_date IS NULL)"
    t.index ["specific_date"], name: "index_business_hours_on_specific_date", unique: true, where: "(specific_date IS NOT NULL)"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "event_date", null: false
    t.string "start_time", null: false
    t.string "end_time"
    t.integer "max_capacity", null: false
    t.decimal "price_per_person", precision: 8, scale: 2, default: "0.0", null: false
    t.string "status", default: "upcoming", null: false
    t.string "event_type"
    t.date "booking_deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date"], name: "index_events_on_event_date"
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "gallery_items", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "alt_text"
    t.string "media_type", default: "photo", null: false
    t.string "category", null: false
    t.string "video_url"
    t.boolean "featured", default: false, null: false
    t.boolean "active", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active", "position"], name: "index_gallery_items_on_active_and_position"
    t.index ["category"], name: "index_gallery_items_on_category"
    t.index ["media_type"], name: "index_gallery_items_on_media_type"
  end

  create_table "menu_categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "category_type"
    t.boolean "active"
    t.integer "display_order"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "alt_text"
    t.decimal "price"
    t.boolean "available"
    t.boolean "featured"
    t.integer "display_order"
    t.bigint "menu_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "dietary_flags"
    t.index ["menu_category_id"], name: "index_menu_items_on_menu_category_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "payment_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.string "currency", default: "INR", null: false
    t.string "status", default: "pending", null: false
    t.datetime "completed_at"
    t.datetime "failed_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_payment_transactions_on_payment_id"
    t.index ["status"], name: "index_payment_transactions_on_status"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.string "currency", default: "INR", null: false
    t.string "status", default: "pending", null: false
    t.string "payment_type", default: "full", null: false
    t.datetime "paid_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "refunded_amount", precision: 10, scale: 2
    t.datetime "refunded_at"
    t.index ["reservation_id"], name: "index_payments_on_reservation_id"
    t.index ["status"], name: "index_payments_on_status"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone"
    t.integer "party_size", null: false
    t.date "reservation_date", null: false
    t.string "reservation_time", null: false
    t.text "special_requests"
    t.string "status", default: "pending", null: false
    t.string "confirmation_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "table_id"
    t.bigint "event_id"
    t.text "notes"
    t.decimal "deposit_amount", precision: 8, scale: 2
    t.decimal "total_amount", precision: 8, scale: 2
    t.string "end_time"
    t.index ["confirmation_code"], name: "index_reservations_on_confirmation_code", unique: true
    t.index ["event_id"], name: "index_reservations_on_event_id"
    t.index ["reservation_date", "reservation_time"], name: "index_reservations_on_reservation_date_and_reservation_time"
    t.index ["table_id"], name: "index_reservations_on_table_id"
  end

  create_table "tables", force: :cascade do |t|
    t.string "number", null: false
    t.integer "capacity", null: false
    t.integer "min_capacity", default: 1, null: false
    t.string "location", default: "indoor", null: false
    t.boolean "active", default: true, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["number"], name: "index_tables_on_number", unique: true
  end

  create_table "team_members", force: :cascade do |t|
    t.string "name", null: false
    t.string "role", null: false
    t.text "bio"
    t.string "instagram_url"
    t.boolean "featured", default: false, null: false
    t.boolean "active", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active", "position"], name: "index_team_members_on_active_and_position"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "menu_items", "menu_categories"
  add_foreign_key "payment_transactions", "payments"
  add_foreign_key "payments", "reservations"
  add_foreign_key "reservations", "events"
  add_foreign_key "reservations", "tables"
end
