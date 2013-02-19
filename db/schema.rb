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

ActiveRecord::Schema.define(:version => 20130218170547) do

  create_table "courts", :force => true do |t|
    t.string   "name"
    t.integer  "court_number"
    t.text     "info"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "area_id"
    t.integer  "cci_identifier"
    t.integer  "cci_code"
    t.integer  "old_id"
    t.integer  "old_postal_address_id"
    t.integer  "old_court_address_id"
    t.integer  "old_court_type_id"
    t.string   "area"
    t.integer  "address_id"
    t.integer  "old_address_postal_flag"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "address_line_4"
    t.string   "postcode"
    t.string   "dx_number"
    t.integer  "court_town_id"
    t.string   "court_latitude"
    t.string   "court_longitude"
  end

end
