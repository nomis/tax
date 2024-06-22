class AddBenefitInKindToGBIncomeMonths < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_income_months, :benefit_in_kind, :decimal, precision: 12, scale: 2, null: false, default: 0
  end
end
