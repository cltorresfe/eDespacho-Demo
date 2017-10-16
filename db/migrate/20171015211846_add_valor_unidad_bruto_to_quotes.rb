class AddValorUnidadBrutoToQuotes < ActiveRecord::Migration
  def change
  	add_column :quotes, :precio_brupo_unidad, :integer
  end
end
