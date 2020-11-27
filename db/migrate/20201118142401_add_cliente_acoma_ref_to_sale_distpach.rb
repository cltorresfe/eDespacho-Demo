class AddClienteAcomaRefToSaleDistpach < ActiveRecord::Migration
  def change
    add_reference :sale_distpaches, :cliente_acomas, index: true, foreign_key: true
  end
end
