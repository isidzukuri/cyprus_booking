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

ActiveRecord::Schema.define(:version => 20140216095559) do

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
    t.string   "currency"
    t.string   "comment"
  end

  create_table "car_cities", :force => true do |t|
    t.string   "name"
    t.string   "lang"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "lat"
    t.float    "lng"
  end

  create_table "car_city_locations", :force => true do |t|
    t.string   "name"
    t.string   "lang"
    t.integer  "country_id"
    t.integer  "car_city_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.float    "lat"
    t.float    "lng"
  end

  create_table "cars_bookings_payeds", :force => true do |t|
    t.string   "reservation_id"
    t.integer  "vehicle_id"
    t.string   "car_name"
    t.float    "base_price"
    t.float    "car_price"
    t.integer  "protect"
    t.float    "protect_price"
    t.string   "pick_country"
    t.string   "pick_city"
    t.string   "pick_place"
    t.string   "pick_location"
    t.date     "pick_date"
    t.string   "pick_time"
    t.string   "drop_country"
    t.string   "drop_city"
    t.string   "drop_place"
    t.string   "drop_location"
    t.date     "drop_date"
    t.string   "drop_time"
    t.string   "driver_name"
    t.string   "driver_surname"
    t.string   "driver_birthday"
    t.text     "cars_extras"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "img_url"
    t.string   "base_currency"
    t.string   "car_cls"
    t.string   "automatic"
    t.string   "car_desc"
    t.string   "car_seats"
    t.string   "car_doors"
    t.string   "car_cancel"
    t.integer  "car_location"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "cars_bookings_payeds", ["user_id"], :name => "index_cars_bookings_payeds_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name_ru"
    t.string   "name_en"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "seo"
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
    t.float  "lat"
    t.float  "lng"
  end

# Could not dump table "countries" because of following StandardError
#   Unknown type 'ingeter' for column 'country_id'

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

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hotel_booking_payeds", :force => true do |t|
    t.integer  "user_id"
    t.string   "sesion_id"
    t.string   "reservation_id"
    t.string   "conf_numbers"
    t.boolean  "with_confirmation"
    t.string   "s_type"
    t.string   "status"
    t.boolean  "reservation_exist"
    t.string   "rooms"
    t.text     "checkin_inst"
    t.string   "arrival_date"
    t.string   "departure_date"
    t.string   "hotel_name"
    t.string   "hotel_address"
    t.string   "room_desc"
    t.text     "cancel_policy"
    t.boolean  "non_refunable"
    t.string   "occupancy_pre_room"
    t.string   "total_price"
    t.string   "price_per_night"
    t.string   "rooms_adt"
    t.string   "rooms_chd"
    t.string   "rooms_names"
    t.string   "base_currency"
    t.boolean  "canceled",           :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "img_url"
    t.string   "desc"
    t.float    "stars"
  end

  create_table "hotel_docs", :force => true do |t|
    t.integer  "adult"
    t.integer  "child"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "bed_type"
    t.string   "bed_type_desc"
    t.string   "smoking_pref"
    t.string   "conf_number"
    t.integer  "hotel_booking_payed_id"
    t.boolean  "canceled",               :default => false
    t.string   "canceled_rooms"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "hotel_locations", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "lang"
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
    t.text    "description_uk", :limit => 255
    t.text    "description_ru", :limit => 255
    t.text    "description_en", :limit => 255
    t.float   "rating",                        :default => 0.0, :null => false
    t.float   "cost",                          :default => 0.0, :null => false
    t.integer "views",                         :default => 0,   :null => false
    t.string  "longitude",                     :default => "0", :null => false
    t.string  "latitude",                      :default => "0", :null => false
    t.string  "full_address"
    t.string  "flat_number"
    t.string  "floor_number"
    t.string  "house_number"
    t.string  "street"
    t.integer "currency_id"
    t.string  "district"
    t.integer "floors"
    t.integer "rooms"
    t.integer "flat_type",                     :default => 1,   :null => false
    t.integer "bed_type",                      :default => 1,   :null => false
    t.integer "places"
    t.integer "showers",                       :default => 1,   :null => false
    t.integer "active",                        :default => 1,   :null => false
    t.integer "user_id"
    t.integer "city_id"
    t.string  "rules"
    t.integer "country_id"
  end

  create_table "houses_nearbies", :id => false, :force => true do |t|
    t.integer "house_id"
    t.integer "nearby_id"
  end

  add_index "houses_nearbies", ["house_id", "nearby_id"], :name => "houses_nearbies_index", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "house_id"
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

  create_table "nearbies", :force => true do |t|
    t.integer  "house_id"
    t.string   "ico_file_name"
    t.string   "name_ru"
    t.string   "name_en"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "category_id"
    t.string   "name_ru"
    t.string   "name_en"
    t.text     "text_ru"
    t.text     "text_en"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "seo"
  end

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

  create_table "rewievs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "house_id"
    t.integer  "status"
    t.string   "text"
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

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "travelers", :force => true do |t|
    t.integer  "apartments_booking_id",                :null => false
    t.string   "name"
    t.string   "email"
    t.integer  "gender",                :default => 1
    t.integer  "is_child",              :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

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
    t.string   "phone_code"
    t.string   "phone"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "file_file_name"
    t.text     "info"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "wishes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "house_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wishes", ["house_id"], :name => "index_wishes_on_house_id"
  add_index "wishes", ["user_id"], :name => "index_wishes_on_user_id"

end
