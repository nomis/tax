class AddSippTargetAdjustToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :sipp_target_adjust, :decimal, precision: 12, scale: 2, null: false, default: 0
  end
end
