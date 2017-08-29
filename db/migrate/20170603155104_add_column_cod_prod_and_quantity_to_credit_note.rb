class AddColumnCodProdAndQuantityToCreditNote < ActiveRecord::Migration
  def change
  	add_column :credit_notes, :cod_product, :string, default: nil
  	add_column :credit_notes, :quantity, :decimal, default: nil
  	add_column :credit_notes, :fecha_crea_softland, :date, default: nil
  end
end
