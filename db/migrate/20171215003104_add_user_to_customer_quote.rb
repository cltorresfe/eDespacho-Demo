class AddUserToCustomerQuote < ActiveRecord::Migration
  def change
  	add_column :customer_quotes, :user_id, :integer
    add_index :customer_quotes, :user_id
  end
end
