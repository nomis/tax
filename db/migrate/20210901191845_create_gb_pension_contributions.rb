class CreateGBPensionContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :gb_pension_contributions do |t|
      t.references :year, null: false, foreign_key: {to_table: :gb_tax_years}
      t.integer :month, null: false
      t.integer :day, null: false

      t.decimal :net_amount, precision: 12, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :gb_pension_contributions, [:year_id, :month, :day], unique: true
  end
end
