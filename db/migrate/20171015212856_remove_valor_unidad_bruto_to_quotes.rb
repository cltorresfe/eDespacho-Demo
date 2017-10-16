class RemoveValorUnidadBrutoToQuotes < ActiveRecord::Migration
  def change
  	remove_column :quotes, :precio_brupo_unidad
  	add_column :quotes, :precio_bruto_unidad, :integer
  end
end
