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

ActiveRecord::Schema.define(:version => 20130304123102) do

  create_table "address_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "address_line_4"
    t.string   "postcode"
    t.string   "dx"
    t.integer  "town_id"
    t.integer  "address_type_id"
    t.integer  "court_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "addresses", ["address_type_id"], :name => "index_addresses_on_address_type_id"
  add_index "addresses", ["court_id"], :name => "index_addresses_on_court_id"
  add_index "addresses", ["town_id"], :name => "index_addresses_on_town_id"

  create_table "counties", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "old_id"
  end

  add_index "counties", ["country_id"], :name => "index_counties_on_country_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "old_id"
  end

  create_table "courts", :force => true do |t|
    t.string   "name"
    t.integer  "court_number"
    t.text     "info"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "area_id"
    t.integer  "cci_identifier"
    t.integer  "cci_code"
    t.integer  "old_id"
    t.integer  "old_court_type_id"
    t.string   "slug"
    t.integer  "old_postal_address_id"
    t.integer  "old_court_address_id"
  end

  add_index "courts", ["slug"], :name => "index_courts_on_slug"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "towns", :force => true do |t|
    t.string   "name"
    t.integer  "county_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "old_id"
  end

  add_index "towns", ["county_id"], :name => "index_towns_on_county_id"

end
