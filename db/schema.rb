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

ActiveRecord::Schema.define(:version => 20131021230417) do

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
    t.string   "status",     :default => "pending"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.string   "pick_up_location"
    t.string   "payment_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "user_cities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "city_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_cities", ["city_id"], :name => "index_followed_cities_on_city_id"
  add_index "user_cities", ["user_id"], :name => "index_followed_cities_on_user_id"

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
  end

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
