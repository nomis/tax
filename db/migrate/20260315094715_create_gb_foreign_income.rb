class CreateGBForeignIncome < ActiveRecord::Migration[6.1]
  def change
    create_table :gb_foreign_income do |t|
      t.references :year, null: false, foreign_key: {to_table: :gb_tax_years}
      t.text :country, null: false

      t.decimal :dividend_income, precision: 12, scale: 2, null: false, default: 0
      t.decimal :dividend_tax_paid, precision: 12, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :gb_foreign_income, [:year_id, :country], unique: true
  end
end
