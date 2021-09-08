class AddFlexibleRemunerationToGBIncomeMonths < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_income_months, :flexible_remuneration, :decimal, precision: 12, scale: 2, null: false, default: 0
  end
end
