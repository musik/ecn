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

ActiveRecord::Schema.define(:version => 20121006122822) do

  create_table "apps", :force => true do |t|
    t.string   "domain"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "opera_address"
    t.string   "zip"
    t.string   "phone"
    t.string   "mobile"
    t.string   "fax"
    t.string   "website"
    t.string   "aliexpress"
    t.string   "email"
    t.string   "btypes"
    t.string   "main_products"
    t.string   "contact"
    t.string   "trackback"
    t.boolean  "fetched"
    t.binary   "meta"
    t.text     "description"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "delta",         :default => true, :null => false
    t.integer  "app_id"
  end

  add_index "companies", ["app_id"], :name => "index_companies_on_app_id"
  add_index "companies", ["delta"], :name => "index_companies_on_delta"
  add_index "companies", ["slug"], :name => "index_companies_on_slug"
  add_index "companies", ["trackback"], :name => "index_trackback"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "kvs", :force => true do |t|
    t.string "k"
    t.string "v"
  end

  add_index "kvs", ["k"], :name => "index_kvs_on_k"

  create_table "products", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "image_src"
    t.string   "trackback"
    t.integer  "company_id"
    t.boolean  "fetched"
    t.binary   "price"
    t.binary   "meta"
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "delta",       :default => true, :null => false
    t.integer  "app_id"
  end

  add_index "products", ["app_id"], :name => "index_products_on_app_id"
  add_index "products", ["company_id"], :name => "imdex_company"
  add_index "products", ["delta"], :name => "index_products_on_delta"
  add_index "products", ["trackback"], :name => "index_trackback"
  add_index "products", ["url"], :name => "index_products_on_url"

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

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "products_count"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "delta",          :default => true, :null => false
    t.integer  "app_id"
  end

  add_index "topics", ["app_id"], :name => "index_topics_on_app_id"
  add_index "topics", ["delta"], :name => "index_topics_on_delta"

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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end