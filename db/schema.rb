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

ActiveRecord::Schema.define(version: 20171104140718) do

  create_table "achievements", force: :cascade do |t|
    t.string "activity_type"
    t.integer "activity_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "completed_on"
    t.integer "daily_total_id"
    t.index ["activity_type", "activity_id"], name: "index_achievements_on_activity_type_and_activity_id"
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "blocked_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_user_id"], name: "index_blocks_on_blocked_user_id"
    t.index ["user_id"], name: "index_blocks_on_user_id"
  end

  create_table "daily_totals", force: :cascade do |t|
    t.integer "total_calories_in", default: 0, null: false
    t.integer "total_calories_out", default: 0, null: false
    t.integer "net_calories", default: 0, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "completed_on"
    t.index ["user_id"], name: "index_daily_totals_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name", null: false
    t.integer "calories_burned", null: false
    t.string "comment", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string "name", null: false
    t.integer "calories", null: false
    t.string "comment", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mutes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "muted_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["muted_user_id"], name: "index_mutes_on_muted_user_id"
    t.index ["user_id"], name: "index_mutes_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
    t.boolean "following_each_other", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_relationships_on_followee_id"
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "quote", default: "", null: false
    t.string "slug"
    t.integer "daily_calorie_intake_goal", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

end
