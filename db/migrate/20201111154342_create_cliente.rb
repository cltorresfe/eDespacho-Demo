class CreateCliente < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.integer :run_cliente
      t.string :dv_cliente
      t.string :nombres_cliente
      t.string :apellidos_cliente

      t.timestamps
    end
  end
end
