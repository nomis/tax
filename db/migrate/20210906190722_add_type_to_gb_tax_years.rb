class AddTypeToGBTaxYears < ActiveRecord::Migration[6.1]
  def change
    add_column :gb_tax_years, :taxpayer_type, :string, null: false, default: "GB-UKM", after: :year
  end
end
