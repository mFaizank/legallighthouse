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

ActiveRecord::Schema.define(version: 20161014020820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "applications", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bar_number"
    t.integer  "year_of_call"
    t.string   "phone_number"
    t.string   "email"
    t.string   "cv"
    t.hstore   "data"
    t.datetime "approved_at"
    t.datetime "rejected_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "specializations", default: [], array: true
    t.text     "languages",       default: [], array: true
    t.text     "bars",            default: [], array: true
    t.string   "token"
    t.string   "locale"
  end

  add_index "applications", ["data"], name: "index_applications_on_data", using: :gin

  create_table "areas", force: :cascade do |t|
    t.string  "name"
    t.integer "lawyer_id"
  end

  add_index "areas", ["lawyer_id"], name: "index_areas_on_lawyer_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.integer  "status",     default: 0
    t.integer  "user_id"
    t.integer  "lawyer_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "clients", ["lawyer_id"], name: "index_clients_on_lawyer_id", using: :btree
  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "consultations", force: :cascade do |t|
    t.datetime "time"
    t.string   "description"
    t.integer  "status",      default: 0
    t.integer  "user_id"
    t.integer  "lawyer_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "consultations", ["lawyer_id"], name: "index_consultations_on_lawyer_id", using: :btree
  add_index "consultations", ["user_id"], name: "index_consultations_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.string   "description"
    t.integer  "user_id"
    t.integer  "lawyer_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "inquiries", ["lawyer_id"], name: "index_inquiries_on_lawyer_id", using: :btree
  add_index "inquiries", ["user_id"], name: "index_inquiries_on_user_id", using: :btree

  create_table "lawyer_leads", force: :cascade do |t|
    t.string   "email"
    t.text     "practices",  default: [],              array: true
    t.datetime "created_at",              null: false
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bars",       default: [],              array: true
  end

  create_table "lawyers", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bar"
    t.integer  "year_of_call"
    t.integer  "hourly_rate"
    t.string   "phone_number"
    t.string   "address"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "bar_number"
    t.string   "cv"
    t.hstore   "data"
    t.text     "specializations",          default: [],                 array: true
    t.boolean  "fixed_fees",               default: false
    t.boolean  "unbundling",               default: false
    t.text     "languages",                default: [],                 array: true
    t.string   "public_id"
    t.string   "profile_image"
    t.string   "designation"
    t.string   "location"
    t.integer  "years_of_experience"
    t.text     "bio"
    t.decimal  "consultation_hourly_rate"
    t.boolean  "listed",                   default: false
    t.string   "stripe_token"
    t.string   "stripe_account_id"
  end

  add_index "lawyers", ["data"], name: "index_lawyers_on_data", using: :gin
  add_index "lawyers", ["email"], name: "index_lawyers_on_email", unique: true, using: :btree
  add_index "lawyers", ["public_id"], name: "index_lawyers_on_public_id", unique: true, using: :btree
  add_index "lawyers", ["reset_password_token"], name: "index_lawyers_on_reset_password_token", unique: true, using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "email",      null: false
    t.boolean  "business"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_requests", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "status"
    t.boolean  "disbursement", default: false
    t.string   "description"
    t.integer  "quote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_requests", ["quote_id"], name: "index_payment_requests_on_quote_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.decimal  "amount",       precision: 8, scale: 2
    t.string   "payment_type"
    t.integer  "quote_id"
    t.integer  "lawyer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["lawyer_id"], name: "index_payments_on_lawyer_id", using: :btree
  add_index "payments", ["quote_id"], name: "index_payments_on_quote_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "proposed_times", force: :cascade do |t|
    t.datetime "time"
    t.integer  "consultation_id"
  end

  add_index "proposed_times", ["consultation_id"], name: "index_proposed_times_on_consultation_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.string   "agreement"
    t.decimal  "fee"
    t.decimal  "advance"
    t.datetime "completion_date"
    t.integer  "lawyer_id"
    t.integer  "user_id"
    t.integer  "status",          default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.decimal  "disbursement"
  end

  add_index "quotes", ["lawyer_id"], name: "index_quotes_on_lawyer_id", using: :btree
  add_index "quotes", ["user_id"], name: "index_quotes_on_user_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "fixed_fee"
    t.boolean  "unbundling",     default: false
    t.string   "specialization",                 null: false
    t.integer  "lawyer_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "case_specific",  default: false
    t.boolean  "starting_at",    default: false
  end

  add_index "services", ["lawyer_id"], name: "index_services_on_lawyer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.string   "phone_number"
    t.string   "postal_code"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.boolean  "business"
    t.string   "occupation"
    t.string   "stripe_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "areas", "lawyers"
  add_foreign_key "clients", "lawyers"
  add_foreign_key "clients", "users"
  add_foreign_key "consultations", "lawyers"
  add_foreign_key "consultations", "users"
  add_foreign_key "inquiries", "lawyers"
  add_foreign_key "inquiries", "users"
  add_foreign_key "payment_requests", "quotes"
  add_foreign_key "payments", "lawyers"
  add_foreign_key "payments", "quotes"
  add_foreign_key "payments", "users"
  add_foreign_key "proposed_times", "consultations"
  add_foreign_key "quotes", "lawyers"
  add_foreign_key "quotes", "users"
  add_foreign_key "services", "lawyers"
end
