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

ActiveRecord::Schema.define(version: 20170601204451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crono_jobs", force: :cascade do |t|
    t.string   "job_id",            null: false
    t.text     "log"
    t.datetime "last_performed_at"
    t.boolean  "healthy"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "crono_jobs", ["job_id"], name: "index_crono_jobs_on_job_id", unique: true, using: :btree

  create_table "easy_tokens_tokens", force: :cascade do |t|
    t.string   "value"
    t.string   "description"
    t.string   "owner_id"
    t.datetime "deactivated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "interval",     default: "daily"
    t.datetime "last_sent_at"
    t.boolean  "active",       default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "mail_subscriptions", ["user_id"], name: "index_mail_subscriptions_on_user_id", unique: true, using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "memberships", ["organisation_id"], name: "index_memberships_on_organisation_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "organisations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "team_id"
    t.string   "token"
    t.string   "slack_channel"
  end

  add_index "organisations", ["name"], name: "index_organisations_on_name", unique: true, using: :btree
  add_index "organisations", ["team_id"], name: "index_organisations_on_team_id", unique: true, using: :btree

  create_table "prop_receivers", force: :cascade do |t|
    t.integer "prop_id"
    t.integer "user_id"
  end

  add_index "prop_receivers", ["prop_id", "user_id"], name: "index_prop_receivers_on_prop_id_and_user_id", unique: true, using: :btree
  add_index "prop_receivers", ["prop_id"], name: "index_prop_receivers_on_prop_id", using: :btree
  add_index "prop_receivers", ["user_id"], name: "index_prop_receivers_on_user_id", using: :btree

  create_table "props", force: :cascade do |t|
    t.integer  "propser_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "upvotes_count",   default: 0
    t.string   "slack_ts"
    t.integer  "organisation_id"
  end

  add_index "props", ["organisation_id"], name: "index_props_on_organisation_id", using: :btree
  add_index "props", ["propser_id"], name: "index_props_on_propser_id", using: :btree

  create_table "upvotes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "prop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "upvotes", ["prop_id"], name: "index_upvotes_on_prop_id", using: :btree
  add_index "upvotes", ["user_id"], name: "index_upvotes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",       default: false
    t.datetime "archived_at"
    t.string   "avatar"
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree

  add_foreign_key "memberships", "organisations"
  add_foreign_key "memberships", "users"
  add_foreign_key "props", "organisations"
end
