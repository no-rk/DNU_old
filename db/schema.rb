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

ActiveRecord::Schema.define(:version => 20130110074725) do

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "game_data_abilities", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_art_types", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_arts", :force => true do |t|
    t.integer  "art_type_id"
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "game_data_arts", ["art_type_id"], :name => "index_game_data_arts_on_art_type_id"

  create_table "game_data_guardians", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "game_data_sups", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_words", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "register_battles", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_battles", ["user_id"], :name => "index_register_battles_on_user_id"

  create_table "register_characters", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_characters", ["user_id"], :name => "index_register_characters_on_user_id"

  create_table "register_competitions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_competitions", ["user_id"], :name => "index_register_competitions_on_user_id"

  create_table "register_duels", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_duels", ["user_id"], :name => "index_register_duels_on_user_id"

  create_table "register_icons", :force => true do |t|
    t.integer  "character_id"
    t.integer  "upload_icon_id"
    t.string   "url"
    t.integer  "number"
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "register_icons", ["character_id"], :name => "index_register_icons_on_character_id"
  add_index "register_icons", ["upload_icon_id"], :name => "index_register_icons_on_upload_icon_id"

  create_table "register_images", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_images", ["user_id"], :name => "index_register_images_on_user_id"

  create_table "register_init_arts", :force => true do |t|
    t.integer  "initial_id"
    t.integer  "art_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_init_arts", ["art_id"], :name => "index_register_init_arts_on_art_id"
  add_index "register_init_arts", ["initial_id"], :name => "index_register_init_arts_on_initial_id"

  create_table "register_init_guardians", :force => true do |t|
    t.integer  "initial_id"
    t.integer  "guardian_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "register_init_guardians", ["guardian_id"], :name => "index_register_init_guardians_on_guardian_id"
  add_index "register_init_guardians", ["initial_id"], :name => "index_register_init_guardians_on_initial_id"

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

  create_table "register_upload_icons", :force => true do |t|
    t.integer  "image_id"
    t.string   "icon"
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_upload_icons", ["image_id"], :name => "index_register_upload_icons_on_image_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

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

  add_foreign_key "notifications", "conversations", :name => "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", :name => "receipts_on_notification_id"

end
