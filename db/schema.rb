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

ActiveRecord::Schema[7.1].define(version: 2025_08_25_120327) do
  create_table "announcements", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "user_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_announcements_on_tournament_id"
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.string "email"
    t.string "token"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invited_user_id"
    t.datetime "expires_at"
    t.index ["invited_user_id"], name: "index_invites_on_invited_user_id"
    t.index ["tournament_id"], name: "index_invites_on_tournament_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "player1_id"
    t.integer "player2_id"
    t.integer "winner_id"
    t.integer "match_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "next_match_id"
    t.integer "position_in_next_match"
    t.string "status"
    t.integer "best_of"
    t.integer "round_number"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "round_number"
    t.integer "player1_score"
    t.integer "player2_score"
    t.integer "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed"
    t.index ["match_id"], name: "index_rounds_on_match_id"
  end

  create_table "tournament_players", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "user_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id", "user_id"], name: "index_tournament_players_on_tournament_id_and_user_id", unique: true
    t.index ["tournament_id"], name: "index_tournament_players_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_players_on_user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "bracket_type"
    t.integer "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_players"
    t.integer "min_players"
    t.string "status", default: "scheduled"
    t.string "description"
    t.index ["created_by_user_id"], name: "index_tournaments_on_created_by_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "announcements", "tournaments"
  add_foreign_key "announcements", "users"
  add_foreign_key "invites", "tournaments"
  add_foreign_key "invites", "users", column: "invited_user_id"
  add_foreign_key "matches", "tournaments"
  add_foreign_key "rounds", "matches"
  add_foreign_key "tournament_players", "tournaments"
  add_foreign_key "tournament_players", "users"
  add_foreign_key "tournaments", "users", column: "created_by_user_id"
end
