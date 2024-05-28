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

ActiveRecord::Schema[7.0].define(version: 2024_05_28_140013) do
  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "login_id", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "category", null: false
    t.integer "price", null: false
    t.integer "genre", null: false
    t.integer "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_menus_on_tenant_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.integer "quantity"
    t.integer "receipt_id"
    t.integer "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_order_details_on_menu_id"
    t.index ["receipt_id"], name: "index_order_details_on_receipt_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.integer "food_value", null: false
    t.integer "drink_value", null: false
    t.integer "status", default: 0, null: false
    t.date "compiled_at"
    t.date "recorded_at", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recorded_at"], name: "index_receipts_on_recorded_at"
    t.index ["status"], name: "index_receipts_on_status"
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name", null: false
    t.integer "industry", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "login_id", null: false
    t.string "password_digest", null: false
    t.string "remember_digest"
    t.integer "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "menus", "tenants"
  add_foreign_key "order_details", "menus"
  add_foreign_key "order_details", "receipts"
  add_foreign_key "receipts", "users"
  add_foreign_key "users", "tenants"
end
