class AddIncomeTargetToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :income_target, :decimal, precision: 12, scale: 2
  end
end
