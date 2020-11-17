class AddRefClienteAcomaToUser < ActiveRecord::Migration
  def change
  	add_reference :cliente_acomas, :user, index: true, foreign_key: true
  	add_index :cliente_acomas, :run_cliente, :unique => true
  end
end
