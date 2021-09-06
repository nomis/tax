class RemoveScoPersonalAllowanceFromGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    remove_column :gb_tax_years, :sco_personal_allowance
  end
end
