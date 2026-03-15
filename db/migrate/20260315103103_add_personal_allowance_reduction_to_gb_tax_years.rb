class AddPersonalAllowanceReductionToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :personal_allowance_reduction_threshold, :decimal, precision: 12, scale: 2
    add_column :gb_tax_years, :personal_allowance_reduction_step, :decimal, precision: 12, scale: 2
    add_column :gb_tax_years, :personal_allowance_reduction_value, :decimal, precision: 12, scale: 2
  end
end
