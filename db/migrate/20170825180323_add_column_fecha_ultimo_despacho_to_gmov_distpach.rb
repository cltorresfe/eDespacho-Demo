class AddColumnFechaUltimoDespachoToGmovDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :fecha_ultimo_despacho, :datetime
  end
end
