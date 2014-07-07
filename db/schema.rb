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

ActiveRecord::Schema.define(version: 20140707193817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "case_types", force: true do |t|
    t.integer  "lawfirm_id"
    t.string   "mat_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "case_types", ["lawfirm_id"], name: "index_case_types_on_lawfirm_id", using: :btree

  create_table "cases", force: true do |t|
    t.string   "matter_reference"
    t.text     "description"
    t.string   "practice_group"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "cases", ["client_id"], name: "index_cases_on_client_id", using: :btree

  create_table "checks", force: true do |t|
    t.integer  "case_id"
    t.date     "conflict_check"
    t.date     "retention_letter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checks", ["case_id"], name: "index_checks_on_case_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "client_name"
    t.string   "client_street_address"
    t.string   "client_city_address"
    t.string   "client_state_address"
    t.string   "client_zip_code"
    t.string   "client_billing_name"
    t.string   "client_billing_street_address"
    t.string   "client_billing_city_address"
    t.string   "client_billing_state_address"
    t.string   "client_billing_zip_code"
    t.string   "client_phone_number"
    t.string   "client_fax_number"
    t.string   "client_email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["user_id", "created_at"], name: "index_clients_on_user_id_and_created_at", using: :btree

  create_table "fees", force: true do |t|
    t.integer  "case_id"
    t.string   "fee_type"
    t.decimal  "high_estimate"
    t.decimal  "medium_estimate"
    t.decimal  "low_estimate"
    t.string   "payment_likelihood"
    t.string   "retainer"
    t.decimal  "cost_estimate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fees", ["case_id"], name: "index_fees_on_case_id", using: :btree

  create_table "key_dates", force: true do |t|
    t.integer  "case_id"
    t.string   "event_name"
    t.date     "event_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "key_dates", ["case_id"], name: "index_key_dates_on_case_id", using: :btree

  create_table "lawfirms", force: true do |t|
    t.string   "firm_name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "originations", force: true do |t|
    t.string   "referral_source"
    t.string   "existing_client"
    t.string   "other_source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "case_id"
  end

  add_index "originations", ["case_id"], name: "index_originations_on_case_id", using: :btree

  create_table "practicegroups", force: true do |t|
    t.integer  "lawfirm_id"
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "practicegroups", ["lawfirm_id"], name: "index_practicegroups_on_lawfirm_id", using: :btree

  create_table "staffings", force: true do |t|
    t.integer  "lawfirm_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staffings", ["lawfirm_id"], name: "index_staffings_on_lawfirm_id", using: :btree

  create_table "staffs", force: true do |t|
    t.integer  "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "position"
    t.integer  "percent_utilization"
    t.integer  "hours_expected"
    t.integer  "staffing_id"
  end

  add_index "staffs", ["case_id"], name: "index_staffs_on_case_id", using: :btree
  add_index "staffs", ["staffing_id"], name: "index_staffs_on_staffing_id", using: :btree

  create_table "timings", force: true do |t|
    t.integer  "case_id"
    t.date     "date_opened"
    t.date     "estimated_conclusion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timings", ["case_id"], name: "index_timings_on_case_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.integer  "lawfirm_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["lawfirm_id"], name: "index_users_on_lawfirm_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "venues", force: true do |t|
    t.string   "jurisdiction"
    t.string   "judge"
    t.integer  "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venues", ["case_id"], name: "index_venues_on_case_id", using: :btree

end
