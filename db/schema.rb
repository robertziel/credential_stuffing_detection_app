# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_01_215121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.inet "ip", null: false
    t.datetime "banned_at"
    t.index ["ip"], name: "index_addresses_on_ip", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.string "value", null: false
    t.datetime "last_detected_at", default: -> { "now()" }, null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_emails_on_address_id"
    t.index ["value"], name: "index_emails_on_value", unique: true
  end

  create_table "events", id: false, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "detected_at", default: -> { "now()" }, null: false
    t.bigint "email_id"
    t.index ["email_id"], name: "index_events_on_email_id"
  end

  create_table "inputs", force: :cascade do |t|
    t.string "email", null: false
    t.string "event_name", null: false
    t.inet "ip", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "emails", "addresses"
  add_foreign_key "events", "emails"
end
