class AddPriceAndTotalToQuotes < ActiveRecord::Migration
  def change
  	add_column :quotes, :tax_iva, :integer
  	add_column :quotes, :total_price, :integer
  end
end
