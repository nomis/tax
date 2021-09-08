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

ActiveRecord::Schema.define(version: 2021_09_08_160200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "gb_income_months", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "year_id", null: false
    t.integer "month", null: false
    t.decimal "basic", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "bonus", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "arrears", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "overtime", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "extra", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "net_pension", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "employer_pension", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "paye_paid", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "flexible_remuneration", precision: 12, scale: 2, default: "0.0", null: false
    t.index ["company_id"], name: "index_gb_income_months_on_company_id"
    t.index ["year_id", "month", "company_id"], name: "index_gb_income_months_on_year_id_and_month_and_company_id", unique: true
    t.index ["year_id"], name: "index_gb_income_months_on_year_id"
  end

  create_table "gb_pension_contributions", force: :cascade do |t|
    t.bigint "year_id", null: false
    t.integer "month", null: false
    t.integer "day", null: false
    t.decimal "net_amount", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["year_id", "month", "day"], name: "index_gb_pension_contributions_on_year_id_and_month_and_day", unique: true
    t.index ["year_id"], name: "index_gb_pension_contributions_on_year_id"
  end

  create_table "gb_tax_years", force: :cascade do |t|
    t.integer "year", null: false
    t.decimal "gross_interest", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "net_interest", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "net_gift_aid", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "dividends", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "foreign_dividend_tax_credit", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "allowable_expenses", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "personal_allowance", precision: 12, scale: 2
    t.decimal "basic_band", precision: 12, scale: 2
    t.decimal "basic_rate", precision: 12, scale: 6
    t.decimal "higher_band", precision: 12, scale: 2
    t.decimal "higher_rate", precision: 12, scale: 6
    t.decimal "additional_rate", precision: 12, scale: 6
    t.decimal "tax_free_interest_at_basic_rate", precision: 12, scale: 2
    t.decimal "tax_free_interest_at_higher_rate", precision: 12, scale: 2
    t.decimal "pension_annual_allowance", precision: 12, scale: 2
    t.decimal "sco_starter_band", precision: 12, scale: 2
    t.decimal "sco_starter_rate", precision: 12, scale: 6
    t.decimal "sco_basic_band", precision: 12, scale: 2
    t.decimal "sco_basic_rate", precision: 12, scale: 6
    t.decimal "sco_intermediate_band", precision: 12, scale: 2
    t.decimal "sco_intermediate_rate", precision: 12, scale: 6
    t.decimal "sco_higher_band", precision: 12, scale: 2
    t.decimal "sco_higher_rate", precision: 12, scale: 6
    t.decimal "sco_additional_rate", precision: 12, scale: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "foreign_dividends", precision: 12, scale: 2, default: "0.0", null: false
    t.string "taxpayer_type", default: "GB-UKM", null: false
    t.decimal "starting_band_for_savings", precision: 12, scale: 2
    t.decimal "starting_rate_for_savings", precision: 12, scale: 6
    t.decimal "pension_annual_allowance_tapering_threshold_income", precision: 12, scale: 2
    t.decimal "pension_annual_allowance_tapering_adjusted_income", precision: 12, scale: 2
    t.decimal "pension_annual_allowance_tapering_min_reduced", precision: 12, scale: 2
    t.index ["year"], name: "index_gb_tax_years_on_year", unique: true
  end

  add_foreign_key "gb_income_months", "companies"
  add_foreign_key "gb_income_months", "gb_tax_years", column: "year_id"
  add_foreign_key "gb_pension_contributions", "gb_tax_years", column: "year_id"
end
