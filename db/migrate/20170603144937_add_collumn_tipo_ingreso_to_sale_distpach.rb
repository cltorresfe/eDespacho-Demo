class AddCollumnTipoIngresoToSaleDistpach < ActiveRecord::Migration
  def change
  	add_column :sale_distpaches, :tipo_ingreso, :string, default: 'IM'
  end
end
