class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.text :name, null: false

      t.timestamps
    end

    add_index :companies, :name, unique: true
  end
end
