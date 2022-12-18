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

ActiveRecord::Schema[7.0].define(version: 2022_12_14_072755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_currencies_on_symbol"
  end

  create_table "deals", force: :cascade do |t|
    t.decimal "amount", precision: 20, scale: 8
    t.bigint "portfolio_id", null: false
    t.bigint "currency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_deals_on_currency_id"
    t.index ["portfolio_id"], name: "index_deals_on_portfolio_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.string "pair", null: false
    t.string "coin1", null: false
    t.string "coin2", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin1"], name: "index_pairs_on_coin1"
    t.index ["coin2"], name: "index_pairs_on_coin2"
  end

  create_table "portfolios", force: :cascade do |t|
    t.boolean "private"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "deals", "currencies"
  add_foreign_key "deals", "portfolios"
  add_foreign_key "portfolios", "users"
end
