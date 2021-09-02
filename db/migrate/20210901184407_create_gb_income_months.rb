class CreateGBIncomeMonths < ActiveRecord::Migration[6.1]
  def change
    create_table :gb_income_months do |t|
      t.references :company, null: false, foreign_key: true
      t.references :year, null: false, foreign_key: {to_table: :gb_tax_years}
      t.integer :month, null: false

      t.decimal :basic, precision: 12, scale: 2, null: false, default: 0
      t.decimal :bonus, precision: 12, scale: 2, null: false, default: 0
      t.decimal :arrears, precision: 12, scale: 2, null: false, default: 0
      t.decimal :overtime, precision: 12, scale: 2, null: false, default: 0
      t.decimal :extra, precision: 12, scale: 2, null: false, default: 0

      t.decimal :net_pension, precision: 12, scale: 2, null: false, default: 0
      t.decimal :employer_pension, precision: 12, scale: 2, null: false, default: 0

      t.decimal :paye_paid, precision: 12, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :gb_income_months, [:year_id, :month, :company_id], unique: true
  end
end
