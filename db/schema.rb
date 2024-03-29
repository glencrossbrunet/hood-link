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

ActiveRecord::Schema.define(version: 20131208152902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "filters", force: true do |t|
    t.string   "key",             null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fume_hoods", force: true do |t|
    t.integer  "organization_id",              null: false
    t.string   "external_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "data",            default: {}
    t.json     "aggregates",      default: {}
  end

  add_index "fume_hoods", ["external_id"], name: "index_fume_hoods_on_external_id", unique: true, using: :btree

  create_table "lines", force: true do |t|
    t.json     "filters"
    t.boolean  "visible"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "lines", ["organization_id"], name: "index_lines_on_organization_id", using: :btree
  add_index "lines", ["user_id"], name: "index_lines_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "organizations", ["subdomain"], name: "index_organizations_on_subdomain", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sample_metrics", force: true do |t|
    t.string "name", null: false
  end

  create_table "samples", force: true do |t|
    t.integer  "fume_hood_id",     null: false
    t.integer  "sample_metric_id", null: false
    t.string   "unit"
    t.float    "value",            null: false
    t.string   "source"
    t.datetime "sampled_at",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "samples", ["fume_hood_id"], name: "index_samples_on_fume_hood_id", using: :btree
  add_index "samples", ["sample_metric_id"], name: "index_samples_on_sample_metric_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
