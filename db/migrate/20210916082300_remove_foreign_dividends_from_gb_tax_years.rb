class RemoveForeignDividendsFromGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    remove_column :gb_tax_years, :foreign_dividends
    remove_column :gb_tax_years, :foreign_dividend_tax_credit
  end
end
