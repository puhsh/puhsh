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

ActiveRecord::Schema.define(:version => 20131017020336) do

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

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_url"
    t.string   "city"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "gender"
    t.string   "facebook_email"
    t.string   "contact_email"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "sign_in_count",      :default => 0
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

end