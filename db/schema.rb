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

ActiveRecord::Schema[8.0].define(version: 2026_09_22_000002) do
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
    t.index ["confirmation_code"], name: "index_reservations_on_confirmation_code", unique: true
    t.index ["reservation_date", "reservation_time"], name: "index_reservations_on_reservation_date_and_reservation_time"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "menu_items", "menu_categories"
end
