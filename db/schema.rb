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

ActiveRecord::Schema.define(:version => 20131019093437) do

  create_table "admin_modules", :force => true do |t|
    t.string   "name"
    t.string   "action"
    t.string   "ico_cls"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_modules_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "admin_module_id"
  end

  create_table "admin_modules_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "admin_module_id"
  end

  create_table "admin_settings", :force => true do |t|
    t.string   "setting"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "apartments_bookings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "seller"
    t.integer  "from_date"
    t.integer  "to_date"
    t.integer  "total_cost"
    t.integer  "house_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "status"
  end

  create_table "banks", :force => true do |t|
    t.string   "name_ua"
    t.string   "name_ru"
    t.string   "bank_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "characteristics", :force => true do |t|
    t.string "name_ru"
    t.string "name_uk"
    t.string "name_en"
  end

  create_table "cities", :force => true do |t|
    t.string "country",  :default => "CY", :null => false
    t.string "zip_code"
    t.string "name_ru"
    t.string "name_uk"
    t.string "name_en"
  end

  create_table "currencies", :force => true do |t|
    t.string   "title"
    t.string   "curs"
    t.string   "ico_file_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "symbol"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.string   "email_type"
    t.text     "html"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employments", :force => true do |t|
    t.integer "house_id"
    t.integer "from_date"
    t.integer "to_date"
    t.integer "status"
  end

  create_table "facilities", :force => true do |t|
    t.string   "name_uk"
    t.string   "name_ru"
    t.string   "name_en"
    t.string   "ico"
    t.string   "ico_file_name"
    t.text     "description"
    t.integer  "active",        :default => 1, :null => false
    t.string   "seo"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "facilities_houses", :force => true do |t|
    t.integer "house_id"
    t.integer "facility_id"
  end

  create_table "house_prices", :force => true do |t|
    t.integer "house_id"
    t.integer "from_date"
    t.integer "to_date"
    t.float   "cost"
  end

  create_table "houses", :force => true do |t|
    t.string  "name_uk"
    t.string  "name_ru"
    t.string  "name_en"
    t.string  "description_uk"
    t.string  "description_ru"
    t.string  "description_en"
    t.float   "rating",         :default => 0.0, :null => false
    t.float   "cost",           :default => 0.0, :null => false
    t.integer "views",          :default => 0,   :null => false
    t.string  "longitude",      :default => "0", :null => false
    t.string  "latitude",       :default => "0", :null => false
    t.string  "full_address"
    t.string  "flat_number"
    t.string  "floor_number"
    t.string  "house_number"
    t.string  "street"
    t.integer "currency_id"
    t.string  "district"
    t.integer "floors"
    t.integer "rooms"
    t.integer "places"
    t.integer "showers"
    t.integer "active",         :default => 1,   :null => false
    t.integer "user_id"
    t.integer "city_id"
  end

  create_table "modules", :force => true do |t|
    t.string   "name"
    t.string   "action"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "modules_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "modules_id"
  end

  create_table "payment_details", :force => true do |t|
    t.integer  "bank_id"
    t.integer  "region_id"
    t.string   "payment_number"
    t.string   "name_ru"
    t.string   "name_ua"
    t.string   "budget_code"
    t.string   "budget_code_name", :limit => 20
    t.string   "edrpo"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "penalties", :force => true do |t|
    t.integer  "user_id"
    t.float    "total_cost"
    t.float    "protocol_penalty"
    t.string   "protocol_number"
    t.string   "protocol_serial"
    t.string   "protocol_date"
    t.integer  "payment_detail_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "has_invoice"
    t.integer  "status"
  end

  add_index "penalties", ["user_id"], :name => "index_penalties_on_user_id"

  create_table "photos", :force => true do |t|
    t.integer  "house_id"
    t.string   "file"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer "house_id"
    t.integer "user_id"
    t.integer "characteristic_id"
    t.integer "value"
  end

  create_table "regions", :force => true do |t|
    t.string   "name_ru"
    t.string   "name_ua"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "role_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "status",       :default => 1,   :null => false
    t.integer  "system",       :default => 1,   :null => false
    t.string   "amount",       :default => "0", :null => false
    t.string   "total_amount", :default => "0", :null => false
    t.string   "commision",    :default => "0", :null => false
    t.integer  "user_id",                       :null => false
    t.integer  "penalty_id",                    :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "transactions", ["penalty_id"], :name => "index_transactions_on_penalty_id"
  add_index "transactions", ["status"], :name => "index_transactions_on_status"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "patronic"
    t.string   "email",                                          :null => false
    t.integer  "active",                          :default => 1, :null => false
    t.string   "city"
    t.string   "street"
    t.string   "building"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
