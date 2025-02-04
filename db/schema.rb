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

ActiveRecord::Schema[7.1].define(version: 2025_02_02_192515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attempts", force: :cascade do |t|
    t.text "code"
    t.string "log"
    t.bigint "user_id", null: false
    t.bigint "problem_id", null: false
    t.bigint "language_id", null: false
    t.integer "result", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "score", default: 0.0, null: false
    t.bigint "contest_id"
    t.index ["contest_id"], name: "index_attempts_on_contest_id"
    t.index ["language_id"], name: "index_attempts_on_language_id"
    t.index ["problem_id"], name: "index_attempts_on_problem_id"
    t.index ["user_id"], name: "index_attempts_on_user_id"
  end

  create_table "contests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_contests_on_organization_id"
  end

  create_table "contests_problems", force: :cascade do |t|
    t.bigint "contest_id", null: false
    t.bigint "problem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_contests_problems_on_contest_id"
    t.index ["problem_id"], name: "index_contests_problems_on_problem_id"
  end

  create_table "contests_users", force: :cascade do |t|
    t.bigint "contest_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_contests_users_on_contest_id"
    t.index ["user_id"], name: "index_contests_users_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "css_name", null: false
    t.string "compiler", null: false
    t.text "placeholder", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problem_tags", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_problem_tags_on_problem_id"
    t.index ["tag_id"], name: "index_problem_tags_on_tag_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "complexity", default: 1
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.text "input", null: false
    t.text "output", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_tests_on_problem_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "login", null: false
    t.string "uid", default: "", null: false
    t.string "login", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_login"
    t.string "full_name"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.string "refresh_token"
    t.datetime "refresh_token_expires_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "attempts", "contests"
  add_foreign_key "attempts", "languages"
  add_foreign_key "attempts", "problems"
  add_foreign_key "attempts", "users"
  add_foreign_key "contests", "organizations"
  add_foreign_key "contests_problems", "contests"
  add_foreign_key "contests_problems", "problems"
  add_foreign_key "contests_users", "contests"
  add_foreign_key "contests_users", "users"
  add_foreign_key "problem_tags", "problems"
  add_foreign_key "problem_tags", "tags"
  add_foreign_key "tests", "problems"
  add_foreign_key "users", "organizations"
end
