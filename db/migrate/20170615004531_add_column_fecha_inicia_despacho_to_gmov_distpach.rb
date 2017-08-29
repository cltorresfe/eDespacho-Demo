class AddColumnFechaIniciaDespachoToGmovDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :fecha_inicia_despacho, :datetime
  end
end
