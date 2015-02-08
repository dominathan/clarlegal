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

ActiveRecord::Schema.define(version: 20150203180144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billings", force: true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "billings", ["client_id"], name: "index_billings_on_client_id", using: :btree

  create_table "case_types", force: true do |t|
    t.integer  "lawfirm_id"
    t.string   "mat_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "case_types", ["lawfirm_id"], name: "index_case_types_on_lawfirm_id", using: :btree

  create_table "cases", force: true do |t|
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "open"
    t.string   "court"
    t.string   "case_number"
    t.string   "opposing_attorney"
    t.string   "judge"
    t.text     "description"
    t.integer  "practicegroup_id"
    t.string   "primary_email"
  end

  add_index "cases", ["client_id"], name: "index_cases_on_client_id", using: :btree
  add_index "cases", ["practicegroup_id"], name: "index_cases_on_practicegroup_id", using: :btree
  add_index "cases", ["primary_email"], name: "index_cases_on_primary_email", using: :btree

  create_table "checks", force: true do |t|
    t.integer  "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "conflict_date"
    t.boolean  "conflict_check"
    t.date     "referring_engagement_letter_date"
    t.date     "client_engagement_letter_date"
    t.boolean  "referring_engagement_letter"
    t.boolean  "client_engagement_letter"
  end

  add_index "checks", ["case_id"], name: "index_checks_on_case_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "first_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "different_billing"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "company"
    t.string   "country"
  end

  add_index "clients", ["user_id", "created_at"], name: "index_clients_on_user_id_and_created_at", using: :btree

  create_table "closeouts", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "case_id"
    t.integer  "total_recovery",               default: 0
    t.integer  "total_gross_fee_received",     default: 0
    t.integer  "total_out_of_pocket_expenses", default: 0
    t.integer  "referring_fees_paid",          default: 0
    t.integer  "total_fee_received",           default: 0
    t.date     "date_fee_received"
    t.string   "fee_type"
  end

  add_index "closeouts", ["case_id"], name: "index_closeouts_on_case_id", using: :btree

  create_table "fees", force: true do |t|
    t.integer  "case_id"
    t.string   "fee_type"
    t.integer  "high_estimate",      default: 0
    t.integer  "medium_estimate",    default: 0
    t.integer  "low_estimate",       default: 0
    t.string   "payment_likelihood"
    t.string   "retainer",           default: "0"
    t.integer  "cost_estimate",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referral",           default: 0
  end

  add_index "fees", ["case_id"], name: "index_fees_on_case_id", using: :btree

  create_table "fixed_fees", force: true do |t|
    t.integer  "case_id"
    t.float    "expected_remaining"
    t.float    "conversion_rate"
    t.float    "actual_earned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fixed_fees", ["case_id"], name: "index_fixed_fees_on_case_id", using: :btree

  create_table "graphs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lawfirms", force: true do |t|
    t.string   "firm_name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "lawfirms", ["user_id"], name: "index_lawfirms_on_user_id", using: :btree

  create_table "matters", force: true do |t|
    t.integer  "case_id"
    t.integer  "case_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matters", ["case_id"], name: "index_matters_on_case_id", using: :btree
  add_index "matters", ["case_type_id"], name: "index_matters_on_case_type_id", using: :btree

  create_table "originations", force: true do |t|
    t.string   "referral_source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "case_id"
    t.string   "source_description"
    t.string   "new_referral_source"
  end

  add_index "originations", ["case_id"], name: "index_originations_on_case_id", using: :btree

  create_table "overheads", force: true do |t|
    t.integer  "rent",                      default: 0
    t.integer  "utilities",                 default: 0
    t.integer  "technology",                default: 0
    t.integer  "hard_costs",                default: 0
    t.integer  "guaranteed_salaries",       default: 0
    t.integer  "other",                     default: 0
    t.integer  "billable_hours_per_lawyer"
    t.integer  "number_of_billable_staff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lawfirm_id"
    t.float    "rate_per_hour"
    t.integer  "year"
  end

  add_index "overheads", ["lawfirm_id"], name: "index_overheads_on_lawfirm_id", using: :btree

  create_table "practicegroups", force: true do |t|
    t.integer  "lawfirm_id"
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "practicegroups", ["lawfirm_id"], name: "index_practicegroups_on_lawfirm_id", using: :btree

  create_table "related_cases", force: true do |t|
    t.integer  "case_id"
    t.integer  "related_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_cases", ["case_id"], name: "index_related_cases_on_case_id", using: :btree
  add_index "related_cases", ["related_case_id"], name: "index_related_cases_on_related_case_id", using: :btree

  create_table "staff_cases", force: true do |t|
    t.integer  "staffing_id"
    t.integer  "case_id"
    t.boolean  "current_case"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hours_expected"
    t.integer  "hours_actual"
  end

  add_index "staff_cases", ["case_id"], name: "index_staff_cases_on_case_id", using: :btree
  add_index "staff_cases", ["staffing_id"], name: "index_staff_cases_on_staffing_id", using: :btree

  create_table "staffings", force: true do |t|
    t.integer  "lawfirm_id"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hourly_rate"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "middle_initial"
    t.string   "email"
  end

  add_index "staffings", ["lawfirm_id"], name: "index_staffings_on_lawfirm_id", using: :btree

  create_table "staffs", force: true do |t|
    t.integer  "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "position"
    t.integer  "percent_utilization"
    t.integer  "staffing_id"
    t.integer  "hours_actual",        default: 0
    t.integer  "hours_expected",      default: 0
  end

  add_index "staffs", ["case_id"], name: "index_staffs_on_case_id", using: :btree
  add_index "staffs", ["staffing_id"], name: "index_staffs_on_staffing_id", using: :btree

  create_table "static_informations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timings", force: true do |t|
    t.integer  "case_id"
    t.date     "date_opened"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "case_filed"
    t.date     "estimated_conclusion_fast"
    t.date     "estimated_conclusion_expected"
    t.date     "estimated_conclusion_slow"
  end

  add_index "timings", ["case_id"], name: "index_timings_on_case_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",             default: false
    t.integer  "lawfirm_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "practice_groups"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "middle_initial"
    t.boolean  "dashboard_access"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["lawfirm_id"], name: "index_users_on_lawfirm_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
