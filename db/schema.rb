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

ActiveRecord::Schema.define(:version => 20130111083433) do

  create_table "applications", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name",        :null => false
    t.integer  "user_id",     :null => false
    t.text     "environment", :null => false
  end

  add_index "applications", ["name"], :name => "index_applications_on_name"
  add_index "applications", ["user_id"], :name => "index_applications_on_user_id"

  create_table "public_keys", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id",    :null => false
    t.text     "key",        :null => false
    t.string   "url",        :null => false
    t.string   "title",      :null => false
    t.boolean  "verified",   :null => false
  end

  add_index "public_keys", ["user_id"], :name => "index_public_keys_on_user_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "name",                            :null => false
    t.string   "github_login",                    :null => false
    t.integer  "github_id",                       :null => false
    t.string   "access_token",                    :null => false
    t.boolean  "invited",      :default => false, :null => false
  end

end
