class CreatePrinter < ActiveRecord::Migration
  def change
    create_table :printers do |t|
      t.integer :folio
      t.datetime :imprime_at
      t.integer :id_gsaen
      t.string :type_doc
      t.integer :codigo_bodega
    end
  end
end
