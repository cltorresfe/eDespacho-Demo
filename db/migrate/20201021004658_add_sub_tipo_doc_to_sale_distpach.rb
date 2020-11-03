class AddSubTipoDocToSaleDistpach < ActiveRecord::Migration
  def change
    add_column :sale_distpaches, :subTipoDoc, :string, default: "XY"
  end
end
