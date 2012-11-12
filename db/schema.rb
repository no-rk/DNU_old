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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121112041343) do

  create_table "game_data_jobs", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_statuses", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "register_characters", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_characters", ["user_id"], :name => "index_register_characters_on_user_id"

  create_table "register_init_jobs", :force => true do |t|
    t.integer  "initial_id"
    t.integer  "job_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_init_jobs", ["initial_id"], :name => "index_register_init_jobs_on_initial_id"
  add_index "register_init_jobs", ["job_id"], :name => "index_register_init_jobs_on_job_id"

  create_table "register_init_statuses", :force => true do |t|
    t.integer  "initial_id"
    t.integer  "status_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_init_statuses", ["initial_id"], :name => "index_register_init_statuses_on_initial_id"
  add_index "register_init_statuses", ["status_id"], :name => "index_register_init_statuses_on_status_id"

  create_table "register_initials", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_initials", ["user_id"], :name => "index_register_initials_on_user_id"

  create_table "register_mains", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_mains", ["user_id"], :name => "index_register_mains_on_user_id"

  create_table "register_makes", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_makes", ["user_id"], :name => "index_register_makes_on_user_id"

  create_table "register_products", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_products", ["user_id"], :name => "index_register_products_on_user_id"

  create_table "register_profiles", :force => true do |t|
    t.integer  "character_id"
    t.string   "name"
    t.string   "nickname"
    t.string   "race"
    t.string   "gender"
    t.string   "age"
    t.text     "introduction"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "register_profiles", ["character_id"], :name => "index_register_profiles_on_character_id"

  create_table "register_trades", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_trades", ["user_id"], :name => "index_register_trades_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
