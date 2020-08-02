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

ActiveRecord::Schema.define(version: 2020_08_02_154229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.inet "ip", null: false
    t.datetime "banned_at"
    t.index ["ip"], name: "index_addresses_on_ip", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.string "value", null: false
    t.datetime "last_detected_at", null: false
    t.bigint "event_id"
    t.index ["event_id"], name: "index_emails_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_events_on_address_id"
    t.index ["name"], name: "index_events_on_name", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "detected_at", null: false
    t.bigint "event_id"
    t.index ["event_id"], name: "index_requests_on_event_id"
  end

  add_foreign_key "emails", "events"
  add_foreign_key "events", "addresses"
  add_foreign_key "requests", "events"
end
