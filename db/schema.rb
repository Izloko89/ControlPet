# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150608232805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "email_address", limit: 255
    t.string   "phone_number",  limit: 255
    t.string   "address",       limit: 255
    t.string   "city",          limit: 255
    t.string   "state",         limit: 255
    t.string   "zip",           limit: 255
    t.boolean  "published",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "item_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "item_categories", ["name"], name: "index_item_categories_on_name", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "sku",              limit: 255
    t.string   "name",             limit: 255
    t.text     "description"
    t.decimal  "price",                        precision: 8, scale: 2
    t.integer  "stock_amount"
    t.integer  "amount_sold",                                          default: 0
    t.decimal  "cost_price",                   precision: 8, scale: 2
    t.boolean  "published",                                            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_category_id"
    t.integer  "user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "quantity",                            default: 1
    t.decimal  "price",       precision: 8, scale: 2
    t.decimal  "total_price", precision: 8, scale: 2
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "sale_id"
    t.decimal  "amount",                   precision: 8, scale: 2
    t.string   "payment_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount",           precision: 8, scale: 2
    t.decimal  "total_amount",     precision: 8, scale: 2
    t.decimal  "remaining_amount"
    t.decimal  "discount",         precision: 8, scale: 2
    t.decimal  "tax",              precision: 8, scale: 2
    t.integer  "customer_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sale_by_vet"
  end

  create_table "store_configurations", force: :cascade do |t|
    t.string   "store_name",        limit: 255
    t.text     "store_description"
    t.string   "email_address",     limit: 255
    t.string   "phone_number",      limit: 255
    t.string   "website_url",       limit: 255
    t.string   "address",           limit: 255
    t.string   "city",              limit: 255
    t.string   "state",             limit: 255
    t.string   "zip",               limit: 255
    t.integer  "currency"
    t.decimal  "tax_rate",                      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",                 limit: 255, default: "",    null: false
    t.string   "email",                    limit: 255, default: "",    null: false
    t.string   "encrypted_password",       limit: 255, default: "",    null: false
    t.string   "reset_password_token",     limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",       limit: 255
    t.string   "last_sign_in_ip",          limit: 255
    t.boolean  "can_update_users",                     default: false
    t.boolean  "can_update_items",                     default: true
    t.boolean  "can_update_configuration",             default: false
    t.boolean  "can_view_reports",                     default: false
    t.boolean  "can_update_sale_discount",             default: false
    t.boolean  "can_remove_sales",                     default: false
    t.boolean  "is_admin",                             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
