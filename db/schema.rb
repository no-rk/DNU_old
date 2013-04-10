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

ActiveRecord::Schema.define(:version => 20130410060455) do

  create_table "admins", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "days", :force => true do |t|
    t.integer  "day"
    t.integer  "state",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "game_data_abilities", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_ability_definitions", :force => true do |t|
    t.integer  "ability_id"
    t.string   "kind"
    t.integer  "lv"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_data_ability_definitions", ["ability_id"], :name => "index_game_data_ability_definitions_on_ability_id"

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

  create_table "game_data_battle_settings", :force => true do |t|
    t.string   "kind"
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_battle_values", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_characters", :force => true do |t|
    t.string   "kind"
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_diseases", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.text     "caption"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_elements", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.string   "color"
    t.string   "anti"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "game_data_learning_conditions", :force => true do |t|
    t.integer  "learnable_id"
    t.string   "learnable_type"
    t.integer  "condition_group"
    t.integer  "group_count"
    t.string   "name"
    t.integer  "lv"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "game_data_learning_conditions", ["learnable_id"], :name => "index_game_data_learning_conditions_on_learnable_id"

  create_table "game_data_map_tips", :force => true do |t|
    t.integer  "map_id"
    t.integer  "x"
    t.integer  "y"
    t.string   "landform"
    t.boolean  "collision"
    t.integer  "opacity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_data_map_tips", ["map_id"], :name => "index_game_data_map_tips_on_map_id"

  create_table "game_data_maps", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.string   "base"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_points", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.boolean  "non_negative"
    t.boolean  "protect"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "game_data_products", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_skills", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_statuses", :force => true do |t|
    t.string   "name"
    t.text     "caption"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_sups", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_trains", :force => true do |t|
    t.integer  "trainable_id"
    t.string   "trainable_type"
    t.boolean  "visible"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "game_data_trains", ["trainable_id"], :name => "index_game_data_trains_on_trainable_id"

  create_table "game_data_traps", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_data_weapons", :force => true do |t|
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

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

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

  create_table "register_abilities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_abilities", ["day_id"], :name => "index_register_abilities_on_day_id"
  add_index "register_abilities", ["user_id"], :name => "index_register_abilities_on_user_id"

  create_table "register_ability_settings", :force => true do |t|
    t.integer  "ability_id"
    t.string   "kind"
    t.integer  "ability_definition_id"
    t.boolean  "setting"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "register_ability_settings", ["ability_definition_id"], :name => "index_register_ability_settings_on_ability_definition_id"
  add_index "register_ability_settings", ["ability_id"], :name => "index_register_ability_settings_on_ability_id"

  create_table "register_battle_settings", :force => true do |t|
    t.integer  "battlable_id"
    t.string   "battlable_type"
    t.integer  "skill_id"
    t.integer  "priority"
    t.string   "use_condition"
    t.string   "use_condition_variable"
    t.string   "frequency"
    t.string   "target"
    t.string   "target_variable"
    t.text     "message"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "register_battle_settings", ["battlable_id"], :name => "index_register_battle_settings_on_battlable_id"
  add_index "register_battle_settings", ["skill_id"], :name => "index_register_battle_settings_on_skill_id"

  create_table "register_battles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_battles", ["day_id"], :name => "index_register_battles_on_day_id"
  add_index "register_battles", ["user_id"], :name => "index_register_battles_on_user_id"

  create_table "register_blossoms", :force => true do |t|
    t.integer  "main_id"
    t.integer  "train_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_blossoms", ["main_id"], :name => "index_register_blossoms_on_main_id"
  add_index "register_blossoms", ["train_id"], :name => "index_register_blossoms_on_train_id"

  create_table "register_characters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_characters", ["day_id"], :name => "index_register_characters_on_day_id"
  add_index "register_characters", ["user_id"], :name => "index_register_characters_on_user_id"

  create_table "register_competitions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_competitions", ["day_id"], :name => "index_register_competitions_on_day_id"
  add_index "register_competitions", ["user_id"], :name => "index_register_competitions_on_user_id"

  create_table "register_duels", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_duels", ["day_id"], :name => "index_register_duels_on_day_id"
  add_index "register_duels", ["user_id"], :name => "index_register_duels_on_user_id"

  create_table "register_forgets", :force => true do |t|
    t.integer  "main_id"
    t.integer  "train_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_forgets", ["main_id"], :name => "index_register_forgets_on_main_id"
  add_index "register_forgets", ["train_id"], :name => "index_register_forgets_on_train_id"

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
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_mains", ["day_id"], :name => "index_register_mains_on_day_id"
  add_index "register_mains", ["user_id"], :name => "index_register_mains_on_user_id"

  create_table "register_makes", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_makes", ["user_id"], :name => "index_register_makes_on_user_id"

  create_table "register_moves", :force => true do |t|
    t.integer  "main_id"
    t.integer  "direction"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_moves", ["main_id"], :name => "index_register_moves_on_main_id"

  create_table "register_party_slogans", :force => true do |t|
    t.integer  "main_id"
    t.string   "kind"
    t.string   "slogan"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_party_slogans", ["main_id"], :name => "index_register_party_slogans_on_main_id"

  create_table "register_products", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_products", ["day_id"], :name => "index_register_products_on_day_id"
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

  create_table "register_send_points", :force => true do |t|
    t.integer  "trade_id"
    t.integer  "point_id"
    t.integer  "user_id"
    t.integer  "value"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_send_points", ["point_id"], :name => "index_register_send_points_on_point_id"
  add_index "register_send_points", ["trade_id"], :name => "index_register_send_points_on_trade_id"
  add_index "register_send_points", ["user_id"], :name => "index_register_send_points_on_user_id"

  create_table "register_trades", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_trades", ["day_id"], :name => "index_register_trades_on_day_id"
  add_index "register_trades", ["user_id"], :name => "index_register_trades_on_user_id"

  create_table "register_trains", :force => true do |t|
    t.integer  "main_id"
    t.integer  "train_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_trains", ["main_id"], :name => "index_register_trains_on_main_id"
  add_index "register_trains", ["train_id"], :name => "index_register_trains_on_train_id"

  create_table "register_upload_icons", :force => true do |t|
    t.integer  "image_id"
    t.string   "icon"
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "register_upload_icons", ["image_id"], :name => "index_register_upload_icons_on_image_id"

  create_table "result_abilities", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "ability_id"
    t.string   "name"
    t.text     "caption"
    t.integer  "lv"
    t.integer  "lv_exp"
    t.integer  "lv_cap"
    t.integer  "lv_cap_exp"
    t.boolean  "forget"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_abilities", ["ability_id"], :name => "index_result_abilities_on_ability_id"
  add_index "result_abilities", ["character_id"], :name => "index_result_abilities_on_character_id"
  add_index "result_abilities", ["day_id"], :name => "index_result_abilities_on_day_id"

  create_table "result_arts", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "art_id"
    t.string   "name"
    t.text     "caption"
    t.integer  "lv"
    t.integer  "lv_exp"
    t.integer  "lv_cap"
    t.integer  "lv_cap_exp"
    t.boolean  "forget"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_arts", ["art_id"], :name => "index_result_arts_on_art_id"
  add_index "result_arts", ["character_id"], :name => "index_result_arts_on_character_id"
  add_index "result_arts", ["day_id"], :name => "index_result_arts_on_day_id"

  create_table "result_blossoms", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "blossomable_id"
    t.string   "blossomable_type"
    t.boolean  "success"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "result_blossoms", ["blossomable_id"], :name => "index_result_blossoms_on_blossomable_id"
  add_index "result_blossoms", ["day_id"], :name => "index_result_blossoms_on_day_id"
  add_index "result_blossoms", ["user_id"], :name => "index_result_blossoms_on_user_id"

  create_table "result_forgets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "forgettable_id"
    t.string   "forgettable_type"
    t.boolean  "success"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "result_forgets", ["day_id"], :name => "index_result_forgets_on_day_id"
  add_index "result_forgets", ["forgettable_id"], :name => "index_result_forgets_on_forgettable_id"
  add_index "result_forgets", ["user_id"], :name => "index_result_forgets_on_user_id"

  create_table "result_inventories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "number"
    t.integer  "item_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_inventories", ["day_id"], :name => "index_result_inventories_on_day_id"
  add_index "result_inventories", ["item_id"], :name => "index_result_inventories_on_item_id"
  add_index "result_inventories", ["user_id"], :name => "index_result_inventories_on_user_id"

  create_table "result_item_elements", :force => true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "way_id"
    t.string   "way_type"
    t.integer  "element_id"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_item_elements", ["day_id"], :name => "index_result_item_elements_on_day_id"
  add_index "result_item_elements", ["element_id"], :name => "index_result_item_elements_on_element_id"
  add_index "result_item_elements", ["item_id"], :name => "index_result_item_elements_on_item_id"
  add_index "result_item_elements", ["source_id"], :name => "index_result_item_elements_on_source_id"
  add_index "result_item_elements", ["user_id"], :name => "index_result_item_elements_on_user_id"
  add_index "result_item_elements", ["way_id"], :name => "index_result_item_elements_on_way_id"

  create_table "result_item_names", :force => true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "way_id"
    t.string   "way_type"
    t.string   "name"
    t.text     "caption"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_item_names", ["day_id"], :name => "index_result_item_names_on_day_id"
  add_index "result_item_names", ["item_id"], :name => "index_result_item_names_on_item_id"
  add_index "result_item_names", ["source_id"], :name => "index_result_item_names_on_source_id"
  add_index "result_item_names", ["user_id"], :name => "index_result_item_names_on_user_id"
  add_index "result_item_names", ["way_id"], :name => "index_result_item_names_on_way_id"

  create_table "result_item_strengths", :force => true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "way_id"
    t.string   "way_type"
    t.integer  "strength"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_item_strengths", ["day_id"], :name => "index_result_item_strengths_on_day_id"
  add_index "result_item_strengths", ["item_id"], :name => "index_result_item_strengths_on_item_id"
  add_index "result_item_strengths", ["source_id"], :name => "index_result_item_strengths_on_source_id"
  add_index "result_item_strengths", ["user_id"], :name => "index_result_item_strengths_on_user_id"
  add_index "result_item_strengths", ["way_id"], :name => "index_result_item_strengths_on_way_id"

  create_table "result_item_sups", :force => true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "way_id"
    t.string   "way_type"
    t.string   "kind"
    t.integer  "sup_id"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_item_sups", ["day_id"], :name => "index_result_item_sups_on_day_id"
  add_index "result_item_sups", ["item_id"], :name => "index_result_item_sups_on_item_id"
  add_index "result_item_sups", ["source_id"], :name => "index_result_item_sups_on_source_id"
  add_index "result_item_sups", ["sup_id"], :name => "index_result_item_sups_on_sup_id"
  add_index "result_item_sups", ["user_id"], :name => "index_result_item_sups_on_user_id"
  add_index "result_item_sups", ["way_id"], :name => "index_result_item_sups_on_way_id"

  create_table "result_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "way_id"
    t.string   "way_type"
    t.integer  "plan_id"
    t.string   "plan_type"
    t.integer  "type_id"
    t.string   "type_type"
    t.boolean  "protect"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_items", ["day_id"], :name => "index_result_items_on_day_id"
  add_index "result_items", ["plan_id"], :name => "index_result_items_on_plan_id"
  add_index "result_items", ["source_id"], :name => "index_result_items_on_source_id"
  add_index "result_items", ["type_id"], :name => "index_result_items_on_type_id"
  add_index "result_items", ["user_id"], :name => "index_result_items_on_user_id"
  add_index "result_items", ["way_id"], :name => "index_result_items_on_way_id"

  create_table "result_jobs", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "job_id"
    t.string   "name"
    t.text     "caption"
    t.integer  "lv"
    t.integer  "lv_exp"
    t.integer  "lv_cap"
    t.integer  "lv_cap_exp"
    t.boolean  "forget"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_jobs", ["character_id"], :name => "index_result_jobs_on_character_id"
  add_index "result_jobs", ["day_id"], :name => "index_result_jobs_on_day_id"
  add_index "result_jobs", ["job_id"], :name => "index_result_jobs_on_job_id"

  create_table "result_learns", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "learnable_id"
    t.string   "learnable_type"
    t.boolean  "first"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_learns", ["day_id"], :name => "index_result_learns_on_day_id"
  add_index "result_learns", ["learnable_id"], :name => "index_result_learns_on_learnable_id"
  add_index "result_learns", ["user_id"], :name => "index_result_learns_on_user_id"

  create_table "result_maps", :force => true do |t|
    t.integer  "day_id"
    t.integer  "map_id"
    t.binary   "image",      :limit => 16777215
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "result_maps", ["day_id"], :name => "index_result_maps_on_day_id"
  add_index "result_maps", ["map_id"], :name => "index_result_maps_on_map_id"

  create_table "result_moves", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "direction"
    t.integer  "from_id"
    t.integer  "to_id"
    t.boolean  "success"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_moves", ["day_id"], :name => "index_result_moves_on_day_id"
  add_index "result_moves", ["from_id"], :name => "index_result_moves_on_from_id"
  add_index "result_moves", ["to_id"], :name => "index_result_moves_on_to_id"
  add_index "result_moves", ["user_id"], :name => "index_result_moves_on_user_id"

  create_table "result_notices", :force => true do |t|
    t.integer  "party_id"
    t.string   "kind"
    t.integer  "enemy_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_notices", ["enemy_id"], :name => "index_result_notices_on_enemy_id"
  add_index "result_notices", ["party_id"], :name => "index_result_notices_on_party_id"

  create_table "result_parties", :force => true do |t|
    t.integer  "day_id"
    t.string   "kind"
    t.string   "name"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_parties", ["day_id"], :name => "index_result_parties_on_day_id"

  create_table "result_party_members", :force => true do |t|
    t.integer  "party_id"
    t.integer  "character_id"
    t.string   "character_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_party_members", ["character_id"], :name => "index_result_party_members_on_character_id"
  add_index "result_party_members", ["party_id"], :name => "index_result_party_members_on_party_id"

  create_table "result_places", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "map_tip_id"
    t.boolean  "arrival"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "result_places", ["day_id"], :name => "index_result_places_on_day_id"
  add_index "result_places", ["map_tip_id"], :name => "index_result_places_on_map_tip_id"
  add_index "result_places", ["user_id"], :name => "index_result_places_on_user_id"

  create_table "result_points", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "point_id"
    t.integer  "value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_points", ["character_id"], :name => "index_result_points_on_character_id"
  add_index "result_points", ["day_id"], :name => "index_result_points_on_day_id"
  add_index "result_points", ["point_id"], :name => "index_result_points_on_point_id"

  create_table "result_products", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "product_id"
    t.string   "name"
    t.text     "caption"
    t.integer  "lv"
    t.integer  "lv_exp"
    t.integer  "lv_cap"
    t.integer  "lv_cap_exp"
    t.boolean  "forget"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_products", ["character_id"], :name => "index_result_products_on_character_id"
  add_index "result_products", ["day_id"], :name => "index_result_products_on_day_id"
  add_index "result_products", ["product_id"], :name => "index_result_products_on_product_id"

  create_table "result_skills", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "skill_id"
    t.string   "name"
    t.text     "caption"
    t.integer  "exp"
    t.boolean  "forget"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_skills", ["character_id"], :name => "index_result_skills_on_character_id"
  add_index "result_skills", ["day_id"], :name => "index_result_skills_on_day_id"
  add_index "result_skills", ["skill_id"], :name => "index_result_skills_on_skill_id"

  create_table "result_statuses", :force => true do |t|
    t.integer  "character_id"
    t.string   "character_type"
    t.integer  "day_id"
    t.integer  "status_id"
    t.string   "name"
    t.text     "caption"
    t.integer  "count"
    t.integer  "bonus"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_statuses", ["character_id"], :name => "index_result_statuses_on_character_id"
  add_index "result_statuses", ["day_id"], :name => "index_result_statuses_on_day_id"
  add_index "result_statuses", ["status_id"], :name => "index_result_statuses_on_status_id"

  create_table "result_trains", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "trainable_id"
    t.string   "trainable_type"
    t.integer  "from"
    t.integer  "to"
    t.boolean  "success"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "result_trains", ["day_id"], :name => "index_result_trains_on_day_id"
  add_index "result_trains", ["trainable_id"], :name => "index_result_trains_on_trainable_id"
  add_index "result_trains", ["user_id"], :name => "index_result_trains_on_user_id"

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
    t.integer  "creation_day"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  add_foreign_key "notifications", "conversations", :name => "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", :name => "receipts_on_notification_id"

end
