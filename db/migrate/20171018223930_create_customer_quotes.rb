class CreateCustomerQuotes < ActiveRecord::Migration
  def change
    create_table :customer_quotes do |t|
      t.string :email
      t.string :full_name
      t.string :rut
      t.string :address
      t.integer :total_quote

      t.timestamps
    end
  end
end
