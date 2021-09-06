class AddStartingRateForSavingsToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :starting_band_for_savings, :decimal, precision: 12, scale: 2, before: :tax_free_interest_at_basic_rate
    add_column :gb_tax_years, :starting_rate_for_savings, :decimal, precision: 12, scale: 6, before: :starting_band_for_savings
  end
end
