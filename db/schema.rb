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

ActiveRecord::Schema.define(:version => 20131112025437) do

  create_table "access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expires_at", :default => '2013-11-09 15:03:25'
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "access_tokens", ["token"], :name => "index_access_tokens_on_token"
  add_index "access_tokens", ["user_id"], :name => "index_access_tokens_on_user_id"

  create_table "app_invites", :force => true do |t|
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
    t.integer  "user_id"
  end

  add_index "app_invites", ["status"], :name => "index_waiting_lists_on_status"

  create_table "badges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "badges", ["name"], :name => "index_badges_on_name"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "status",     :default => "active"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "cities", :force => true do |t|
    t.string "zipcode"
    t.string "state"
    t.string "city"
    t.float  "latitude"
    t.float  "longitude"
  end

  add_index "cities", ["latitude"], :name => "index_cities_on_latitude"
  add_index "cities", ["longitude"], :name => "index_cities_on_longitude"
  add_index "cities", ["zipcode"], :name => "index_cities_on_zipcode"

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "device_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"

  create_table "flagged_posts", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "flagged_posts", ["post_id"], :name => "index_flagged_posts_on_post_id"
  add_index "flagged_posts", ["user_id"], :name => "index_flagged_posts_on_user_id"

  create_table "followed_cities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "city_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "followed_cities", ["city_id"], :name => "index_followed_cities_on_city_id"
  add_index "followed_cities", ["user_id"], :name => "index_followed_cities_on_user_id"

  create_table "items", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "price_cents",    :default => 0,     :null => false
    t.string   "price_currency", :default => "USD", :null => false
  end

  add_index "items", ["post_id"], :name => "index_items_on_post_id"

  create_table "offers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "status",          :default => "pending"
    t.string   "question"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "amount_cents",    :default => 0,         :null => false
    t.string   "amount_currency", :default => "USD",     :null => false
  end

  add_index "offers", ["item_id"], :name => "index_offers_on_item_id"
  add_index "offers", ["user_id"], :name => "index_offers_on_user_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "city_id"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.string   "title"
    t.string   "description"
    t.string   "pick_up_location"
    t.string   "payment_type"
    t.integer  "flags_count",      :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"
  add_index "posts", ["city_id"], :name => "index_posts_on_city_id"
  add_index "posts", ["subcategory_id"], :name => "index_posts_on_subcategory_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "rapns_apps", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections", :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "type",                       :null => false
    t.string   "auth_key"
  end

  create_table "rapns_feedback", :force => true do |t|
    t.string   "device_token", :limit => 64, :null => false
    t.datetime "failed_at",                  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "app"
  end

  add_index "rapns_feedback", ["device_token"], :name => "index_rapns_feedback_on_device_token"

  create_table "rapns_notifications", :force => true do |t|
    t.integer  "badge"
    t.string   "device_token",      :limit => 64
    t.string   "sound",                                 :default => "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                                :default => 86400
    t.boolean  "delivered",                             :default => false,     :null => false
    t.datetime "delivered_at"
    t.boolean  "failed",                                :default => false,     :null => false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.boolean  "alert_is_json",                         :default => false
    t.string   "type",                                                         :null => false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                      :default => false,     :null => false
    t.text     "registration_ids",  :limit => 16777215
    t.integer  "app_id",                                                       :null => false
    t.integer  "retries",                               :default => 0
  end

  add_index "rapns_notifications", ["app_id", "delivered", "failed", "deliver_after"], :name => "index_rapns_notifications_multi"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "stars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "event"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stars", ["user_id"], :name => "index_stars_on_user_id"

  create_table "subcategories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "status",      :default => "active"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "subcategories", ["category_id"], :name => "index_subcategories_on_category_id"

  create_table "user_badges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_badges", ["badge_id"], :name => "index_user_badges_on_badge_id"
  add_index "user_badges", ["user_id"], :name => "index_user_badges_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_url"
    t.string   "zipcode"
    t.string   "location_description"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "city_id"
    t.string   "gender"
    t.string   "facebook_email"
    t.string   "contact_email"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "posts_count",          :default => 0
    t.integer  "posts_flagged_count",  :default => 0
  end

  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["latitude"], :name => "index_users_on_latitude"
  add_index "users", ["longitude"], :name => "index_users_on_longitude"
  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
