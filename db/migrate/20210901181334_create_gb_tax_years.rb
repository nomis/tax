class CreateGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    create_table :gb_tax_years do |t|
      t.integer :year, null: false

      t.decimal :gross_interest, precision: 12, scale: 2, null: false, default: 0
      t.decimal :net_interest, precision: 12, scale: 2, null: false, default: 0
      t.decimal :net_gift_aid, precision: 12, scale: 2, null: false, default: 0

      t.decimal :allowable_expenses, precision: 12, scale: 2, null: false, default: 0

      t.decimal :personal_allowance, precision: 12, scale: 2
      t.decimal :basic_band, precision: 12, scale: 2
      t.decimal :basic_rate, precision: 12, scale: 6
      t.decimal :higher_band, precision: 12, scale: 2
      t.decimal :higher_rate, precision: 12, scale: 6
      t.decimal :additional_rate, precision: 12, scale: 6

      t.decimal :tax_free_interest_at_basic_rate, precision: 12, scale: 2
      t.decimal :tax_free_interest_at_higher_rate, precision: 12, scale: 2

      t.decimal :pension_annual_allowance, precision: 12, scale: 2

      t.decimal :sco_starter_band, precision: 12, scale: 2
      t.decimal :sco_starter_rate, precision: 12, scale: 6
      t.decimal :sco_basic_band, precision: 12, scale: 2
      t.decimal :sco_basic_rate, precision: 12, scale: 6
      t.decimal :sco_intermediate_band, precision: 12, scale: 2
      t.decimal :sco_intermediate_rate, precision: 12, scale: 6
      t.decimal :sco_higher_band, precision: 12, scale: 2
      t.decimal :sco_higher_rate, precision: 12, scale: 6
      t.decimal :sco_additional_rate, precision: 12, scale: 6

      t.timestamps
    end

    add_index :gb_tax_years, :year, unique: true
  end
end
