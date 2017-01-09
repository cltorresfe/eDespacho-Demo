class ChangueIdStoreStringByIntegerToSaleDistpach < ActiveRecord::Migration
  def change
  	remove_column :sale_distpaches, :id_store, :string
  	add_column :sale_distpaches, :id_store, :integer, default: 51
  end
end
