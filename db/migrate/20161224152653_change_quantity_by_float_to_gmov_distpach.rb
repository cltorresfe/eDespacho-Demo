class ChangeQuantityByFloatToGmovDistpach < ActiveRecord::Migration
  def change
  	  	remove_column :gmov_distpaches, :distpached_quantity, :decimal
  	remove_column :gmov_distpaches, :pending_distpach, :decimal
  	remove_column :gmov_distpaches, :sale_check_quantity, :decimal

  	add_column :gmov_distpaches, :distpached_quantity, :float
  	add_column :gmov_distpaches, :pending_distpach, :float
  	add_column :gmov_distpaches, :sale_check_quantity, :float
  end
end
