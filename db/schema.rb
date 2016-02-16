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

ActiveRecord::Schema.define(version: 20151106111644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "foods", force: :cascade do |t|
    t.integer  "server_id",              null: false
    t.integer  "size",       default: 0, null: false
    t.integer  "x",          default: 0, null: false
    t.integer  "y",          default: 0, null: false
    t.string   "asset"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "session_id",                   null: false
    t.integer  "food_eaten",       default: 0, null: false
    t.integer  "players_eaten",    default: 0, null: false
    t.integer  "traps_eaten",      default: 0, null: false
    t.integer  "highest_mass",     default: 0, null: false
    t.integer  "leaderboard_time", default: 0, null: false
    t.integer  "top_position",     default: 0, null: false
    t.datetime "end_time"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "message",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer  "user_id",                              null: false
    t.integer  "server_id",                            null: false
    t.string   "username"
    t.integer  "x",                        default: 0, null: false
    t.integer  "y",                        default: 0, null: false
    t.integer  "size",                     default: 1, null: false
    t.integer  "food_eaten",               default: 0, null: false
    t.integer  "players_eaten",            default: 0, null: false
    t.integer  "leaderboard_start_time",   default: 0, null: false
    t.integer  "leaderboard_end_time",     default: 0, null: false
    t.integer  "leaderboard_max_time",     default: 0, null: false
    t.integer  "top_leaderboard_position", default: 0, null: false
    t.integer  "match_id"
    t.string   "player_type"
    t.datetime "end_time"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name"
    t.integer  "region"
    t.string   "url"
    t.integer  "player_count", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id",    null: false
    t.integer  "server_id",  null: false
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.text     "facebook"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "preferred_server"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
