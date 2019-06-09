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

ActiveRecord::Schema.define(version: 2019_06_09_012009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "slack_workspace_id", null: false
    t.string "slack_user_id", null: false
    t.string "access_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "remind_logs", force: :cascade do |t|
    t.bigint "reminder_id"
    t.string "slack_channel_id", null: false
    t.string "icon_emoji"
    t.string "icon_name"
    t.string "message", null: false
    t.string "slack_message_ts", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_permalink"
    t.index ["reminder_id"], name: "index_remind_logs_on_reminder_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "slack_channel_id", null: false
    t.string "icon_emoji"
    t.string "icon_name"
    t.string "message", null: false
    t.integer "hour", null: false
    t.integer "minute", null: false
    t.boolean "holiday_included", default: false, null: false
    t.integer "status", limit: 2, null: false
    t.boolean "monday_enabled", default: false, null: false
    t.boolean "tuesday_enabled", default: false, null: false
    t.boolean "wednesday_enabled", default: false, null: false
    t.boolean "thursday_enabled", default: false, null: false
    t.boolean "friday_enabled", default: false, null: false
    t.boolean "saturday_enabled", default: false, null: false
    t.boolean "sunday_enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "scheduled_time", default: "2000-01-01 00:00:00", null: false
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", limit: 2, default: 0, null: false
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "remind_logs", "reminders"
  add_foreign_key "reminders", "users"
end
