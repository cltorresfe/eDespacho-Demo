class RemoveRefToGmovDistpach < ActiveRecord::Migration
  def change
  	remove_reference :gmov_distpaches, :saleDistpach,  index: true, foreign_key: true
  	add_reference :gmov_distpaches, :sale_distpach,  index: true, foreign_key: true
  end
end
