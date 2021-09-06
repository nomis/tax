class AddForeignDividendsToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :foreign_dividends, :decimal, precision: 12, scale: 2, null: false, default: 0, after: :dividends
    rename_column :gb_tax_years, :dividend_tax_credit, :foreign_dividend_tax_credit
  end
end
