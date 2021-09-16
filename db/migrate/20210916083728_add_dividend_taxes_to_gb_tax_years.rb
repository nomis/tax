class AddDividendTaxesToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :dividend_allowance, :decimal, precision: 12, scale: 2, before: :pension_annual_allowance
    add_column :gb_tax_years, :dividend_basic_rate, :decimal, precision: 12, scale: 6, after: :dividend_allowance
    add_column :gb_tax_years, :dividend_higher_rate, :decimal, precision: 12, scale: 6, after: :dividend_basic_rate
    add_column :gb_tax_years, :dividend_additional_rate, :decimal, precision: 12, scale: 6, after: :dividend_higher_rate
  end
end
