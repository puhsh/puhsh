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

ActiveRecord::Schema.define(:version => 20140312012107) do

  create_table "access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expires_at", :default => '2013-11-09 15:03:25'
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "access_tokens", ["token"], :name => "index_access_tokens_on_token"
  add_index "access_tokens", ["user_id"], :name => "index_access_tokens_on_user_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "app_invites", :force => true do |t|
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
    t.integer  "user_id"
  end

  add_index "app_invites", ["status"], :name => "index_app_invites_on_status"
  add_index "app_invites", ["status"], :name => "index_waiting_lists_on_status"
  add_index "app_invites", ["user_id"], :name => "index_app_invites_on_user_id"

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
    t.string "state"
    t.string "name"
  end

  add_index "cities", ["name"], :name => "index_cities_on_city"

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "device_type"
    t.string   "device_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"

  create_table "facebook_test_users", :force => true do |t|
    t.string   "fbid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "facebook_test_users", ["fbid"], :name => "index_facebook_test_users_on_fbid", :unique => true

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

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "followed_user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "follows", ["followed_user_id"], :name => "index_follows_on_followed_user_id"
  add_index "follows", ["user_id"], :name => "index_follows_on_user_id"

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid_invited"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "invites", ["uid_invited"], :name => "index_invites_on_uid_invited"
  add_index "invites", ["user_id"], :name => "index_invites_on_user_id"

  create_table "item_transactions", :force => true do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.integer  "post_id"
    t.integer  "item_id"
    t.integer  "offer_id"
    t.string   "payment_type"
    t.date     "sold_on"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "item_transactions", ["buyer_id"], :name => "index_item_transactions_on_buyer_id"
  add_index "item_transactions", ["item_id"], :name => "index_item_transactions_on_item_id"
  add_index "item_transactions", ["offer_id"], :name => "index_item_transactions_on_offer_id"
  add_index "item_transactions", ["payment_type"], :name => "index_item_transactions_on_payment_type"
  add_index "item_transactions", ["post_id"], :name => "index_item_transactions_on_post_id"
  add_index "item_transactions", ["seller_id"], :name => "index_item_transactions_on_seller_id"

  create_table "items", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "price_cents",    :default => 0,     :null => false
    t.string   "price_currency", :default => "USD", :null => false
  end

  add_index "items", ["post_id"], :name => "index_items_on_post_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "content"
    t.boolean  "read",         :default => false
    t.date     "read_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "actor_id"
    t.string   "actor_type"
    t.integer  "content_id"
    t.string   "content_type"
    t.boolean  "read",         :default => false
    t.date     "read_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "notifications", ["actor_id"], :name => "index_notifications_on_actor_id"
  add_index "notifications", ["actor_type"], :name => "index_notifications_on_actor_type"
  add_index "notifications", ["content_id"], :name => "index_notifications_on_content_id"
  add_index "notifications", ["content_type"], :name => "index_notifications_on_content_type"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "offers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "post_id"
    t.string   "status",          :default => "pending"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "amount_cents",    :default => 0,         :null => false
    t.string   "amount_currency", :default => "USD",     :null => false
  end

  add_index "offers", ["item_id"], :name => "index_offers_on_item_id"
  add_index "offers", ["user_id"], :name => "index_offers_on_user_id"

  create_table "post_images", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "post_images", ["post_id"], :name => "index_post_images_on_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "city_id"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.string   "title"
    t.string   "description"
    t.string   "pick_up_location"
    t.string   "payment_type"
    t.string   "status"
    t.integer  "flags_count",      :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"
  add_index "posts", ["city_id"], :name => "index_posts_on_city_id"
  add_index "posts", ["subcategory_id"], :name => "index_posts_on_subcategory_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "questions", ["item_id"], :name => "index_questions_on_item_id"
  add_index "questions", ["post_id"], :name => "index_questions_on_post_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

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
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "sign_in_count",              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "posts_count",                :default => 0
    t.integer  "posts_flagged_count",        :default => 0
    t.integer  "star_count",                 :default => 0
    t.integer  "unread_notifications_count", :default => 0
  end

  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["latitude"], :name => "index_users_on_latitude"
  add_index "users", ["longitude"], :name => "index_users_on_longitude"
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "wall_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "post_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wall_posts", ["post_type"], :name => "index_wall_posts_on_type"
  add_index "wall_posts", ["user_id"], :name => "index_wall_posts_on_user_id"

  create_table "zipcodes", :force => true do |t|
    t.integer  "city_id"
    t.string   "code"
    t.string   "city_name"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "zipcodes", ["city_id"], :name => "index_zipcodes_on_city_id"
  add_index "zipcodes", ["city_name"], :name => "index_zipcodes_on_city_name"
  add_index "zipcodes", ["latitude"], :name => "index_zipcodes_on_latitude"
  add_index "zipcodes", ["longitude"], :name => "index_zipcodes_on_longitude"

end
