class AddCustomerToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :customer_quote_id, :integer
    add_index :quotes, :customer_quote_id
  end
end
