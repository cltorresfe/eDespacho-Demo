class ChangeClienteAcomaRefToSaleDistpach < ActiveRecord::Migration
  def change
  	remove_reference :sale_distpaches, :cliente_acomas,  index: true, foreign_key: true
  	add_reference :sale_distpaches, :cliente_acoma,  index: true, foreign_key: true
  end
end
