class AddColumnFechaCreaSoftlandToSaleDistpach < ActiveRecord::Migration
  def change
  	add_column :sale_distpaches, :fecha_crea_softland, :datetime
  end
end
