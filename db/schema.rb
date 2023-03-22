# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_22_134033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "currencies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disbursements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "merchant_id", null: false
    t.datetime "has_orders_from"
    t.datetime "has_orders_to"
    t.float "gross_order_value", default: 0.0, null: false
    t.float "commission_amount", default: 0.0, null: false
    t.float "monthly_fee_amount", default: 0.0, null: false
    t.float "total_amount", default: 0.0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "live_on", null: false
    t.integer "live_on_weekday", default: 0, null: false
    t.integer "disbursement_frequency", default: 1, null: false
    t.float "minimum_monthly_fee", default: 0.0, null: false
    t.uuid "currency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_merchants_on_currency_id"
    t.index ["email"], name: "index_merchants_on_email", unique: true
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "merchants", "currencies"
end
