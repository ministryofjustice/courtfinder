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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141218095002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "address_line_1",  limit: 255
    t.string   "address_line_2",  limit: 255
    t.string   "address_line_3",  limit: 255
    t.string   "address_line_4",  limit: 255
    t.string   "postcode",        limit: 255
    t.string   "dx",              limit: 255
    t.integer  "town_id"
    t.integer  "address_type_id"
    t.integer  "court_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "is_primary"
  end

  add_index "addresses", ["address_type_id"], name: "index_addresses_on_address_type_id", using: :btree
  add_index "addresses", ["court_id"], name: "index_addresses_on_court_id", using: :btree
  add_index "addresses", ["town_id"], name: "index_addresses_on_town_id", using: :btree

  create_table "area_of_law_groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "areas", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "region_id"
    t.integer  "old_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "areas", ["region_id"], name: "index_areas_on_region_id", using: :btree

  create_table "areas_of_law", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "old_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "old_ids_split",     limit: 255
    t.string   "action",            limit: 255
    t.integer  "sort"
    t.string   "slug",              limit: 255
    t.boolean  "type_possession",               default: false
    t.boolean  "type_bankruptcy",               default: false
    t.boolean  "type_money_claims",             default: false
    t.boolean  "type_children",                 default: false
    t.boolean  "type_divorce",                  default: false
    t.boolean  "type_adoption",                 default: false
    t.integer  "group_id"
  end

  create_table "areas_of_law_external_links", id: false, force: :cascade do |t|
    t.integer "area_of_law_id"
    t.integer "external_link_id"
  end

  create_table "contact_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "old_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "telephone",       limit: 255
    t.integer  "court_id"
    t.integer  "contact_type_id"
    t.boolean  "in_leaflet"
    t.integer  "sort"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "contacts", ["contact_type_id"], name: "index_contacts_on_contact_type_id", using: :btree
  add_index "contacts", ["court_id"], name: "index_contacts_on_court_id", using: :btree

  create_table "counties", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "country_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "old_id"
  end

  add_index "counties", ["country_id"], name: "index_counties_on_country_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "old_id"
  end

  create_table "court_facilities", force: :cascade do |t|
    t.text     "description"
    t.integer  "court_id"
    t.integer  "facility_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "sort"
  end

  add_index "court_facilities", ["court_id"], name: "index_facilities_on_court_id", using: :btree
  add_index "court_facilities", ["facility_id"], name: "index_facilities_on_facility_type_id", using: :btree

  create_table "court_types", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "old_description", limit: 255
    t.integer  "old_id"
    t.string   "old_ids_split",   limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "slug",            limit: 255
  end

  create_table "court_types_courts", force: :cascade do |t|
    t.integer  "court_id"
    t.integer  "court_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "court_types_courts", ["court_id"], name: "index_court_types_courts_on_court_id", using: :btree
  add_index "court_types_courts", ["court_type_id"], name: "index_court_types_courts_on_court_type_id", using: :btree

  create_table "court_types_external_links", id: false, force: :cascade do |t|
    t.integer "court_type_id"
    t.integer "external_link_id"
  end

  create_table "courts", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.integer  "court_number"
    t.text     "info"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.integer  "area_id"
    t.integer  "cci_identifier"
    t.integer  "cci_code"
    t.integer  "old_id"
    t.integer  "old_court_type_id"
    t.string   "slug",                  limit: 255
    t.integer  "old_postal_address_id"
    t.integer  "old_court_address_id"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.integer  "old_image_id"
    t.string   "image",                 limit: 255
    t.string   "image_description",     limit: 255
    t.string   "image_file",            limit: 255
    t.boolean  "display"
    t.boolean  "gmaps"
    t.string   "alert",                 limit: 255
    t.text     "info_leaflet"
    t.text     "defence_leaflet"
    t.text     "prosecution_leaflet"
    t.text     "juror_leaflet"
    t.text     "directions"
    t.string   "parking_onsite",        limit: 255
    t.string   "parking_offsite",       limit: 255
    t.string   "parking_blue_badge",    limit: 255
    t.string   "uuid"
    t.string   "gov_uk_md5"
    t.datetime "gov_uk_updated_at",                 default: '1970-01-01 00:00:00'
  end

  add_index "courts", ["slug"], name: "index_courts_on_slug", using: :btree
  add_index "courts", ["uuid"], name: "index_courts_on_uuid", unique: true, using: :btree

  create_table "emails", force: :cascade do |t|
    t.string   "address",         limit: 255
    t.integer  "court_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sort"
    t.integer  "contact_type_id"
  end

  add_index "emails", ["court_id"], name: "index_emails_on_court_id", using: :btree

  create_table "external_links", force: :cascade do |t|
    t.string   "text",           limit: 255
    t.string   "url",            limit: 255
    t.boolean  "always_visible",             default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "facilities", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "image",             limit: 255
    t.integer  "old_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "image_description", limit: 255
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "jurisdictions", force: :cascade do |t|
    t.integer  "remit_id",           null: false
    t.integer  "local_authority_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "jurisdictions", ["local_authority_id"], name: "index_jurisdictions_on_local_authority_id", using: :btree
  add_index "jurisdictions", ["remit_id"], name: "index_jurisdictions_on_remit_id", using: :btree

  create_table "local_authorities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "local_authorities", ["name"], name: "index_local_authorities_on_name", using: :btree

  create_table "opening_times", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "court_id"
    t.integer  "opening_type_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sort"
  end

  add_index "opening_times", ["court_id"], name: "index_opening_times_on_court_id", using: :btree
  add_index "opening_times", ["opening_type_id"], name: "index_opening_times_on_opening_type_id", using: :btree

  create_table "opening_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "old_id"
  end

  create_table "postcode_courts", force: :cascade do |t|
    t.string  "postcode",     limit: 255
    t.integer "court_number"
    t.string  "court_name",   limit: 255
    t.integer "court_id"
  end

  add_index "postcode_courts", ["court_number"], name: "index_postcode_courts_on_court_number", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "old_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug",       limit: 255
  end

  create_table "remits", force: :cascade do |t|
    t.integer  "court_id"
    t.integer  "area_of_law_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "single_point_of_entry", default: false, null: false
  end

  add_index "remits", ["area_of_law_id"], name: "index_remits_on_area_of_law_id", using: :btree
  add_index "remits", ["court_id"], name: "index_remits_on_court_id", using: :btree

  create_table "towns", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "county_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "old_id"
  end

  add_index "towns", ["county_id"], name: "index_towns_on_county_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "invitation_token",       limit: 120
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",        limit: 255
    t.boolean  "admin"
    t.string   "name",                   limit: 255
    t.datetime "invitation_created_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.string   "ip",             limit: 255
    t.string   "network",        limit: 255
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
