class ChangeQuantityByDecimalToGmovDistpach < ActiveRecord::Migration
  def change
  	remove_column :gmov_distpaches, :distpached_quantity, :integer
  	remove_column :gmov_distpaches, :pending_distpach, :integer
  	remove_column :gmov_distpaches, :sale_check_quantity, :integer

  	add_column :gmov_distpaches, :distpached_quantity, :decimal
  	add_column :gmov_distpaches, :pending_distpach, :decimal
  	add_column :gmov_distpaches, :sale_check_quantity, :decimal
  end
end
