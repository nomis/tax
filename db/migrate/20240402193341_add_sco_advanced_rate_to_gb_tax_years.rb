class AddScoAdvancedRateToGBTaxYear < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :sco_advanced_band, :decimal, precision: 12, scale: 2
    add_column :gb_tax_years, :sco_advanced_rate, :decimal, precision: 12, scale: 6
    add_column :gb_tax_years, :sco_top_rate, :decimal, precision: 12, scale: 6
  end
end
