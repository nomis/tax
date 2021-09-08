class AddPensionAnnualAllowanceTaperingToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :pension_annual_allowance_tapering_threshold_income, :decimal, precision: 12, scale: 2
    add_column :gb_tax_years, :pension_annual_allowance_tapering_adjusted_income, :decimal, precision: 12, scale: 2
    add_column :gb_tax_years, :pension_annual_allowance_tapering_min_reduced, :decimal, precision: 12, scale: 2
  end
end
