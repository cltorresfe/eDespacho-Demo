class AddCostoProductoAndRemovePrecioBrutoUnidadToQuotes < ActiveRecord::Migration
  def change
  	remove_column :quotes, :precio_bruto_unidad
  	add_column :quotes, :cost_product, :integer
  end
end
