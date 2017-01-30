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

ActiveRecord::Schema.define(version: 20170117234227) do

  create_table "gmov_distpaches", force: true do |t|
    t.string   "id_product"
    t.integer  "id_line_gmov"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "has_credit_note",                default: false
    t.integer  "sale_distpach_id"
    t.string   "name_product"
    t.string   "status"
    t.float    "distpached_quantity", limit: 24
    t.float    "pending_distpach",    limit: 24
    t.float    "sale_check_quantity", limit: 24
    t.string   "measure",                        default: ""
  end

  add_index "gmov_distpaches", ["sale_distpach_id"], name: "index_gmov_distpaches_on_sale_distpach_id"
  add_index "gmov_distpaches", ["user_id"], name: "index_gmov_distpaches_on_user_id"

  create_table "sale_distpaches", force: true do |t|
    t.string   "id_sale_type"
    t.integer  "id_sale"
    t.string   "name_seller"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "folio",        limit: 8
    t.string   "status"
    t.integer  "id_store",               default: 51
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "warehouse_id"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, where: "([email] IS NOT NULL)"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, where: "([reset_password_token] IS NOT NULL)"
  add_index "users", ["warehouse_id"], name: "index_users_on_warehouse_id"

  create_table "warehouses", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
