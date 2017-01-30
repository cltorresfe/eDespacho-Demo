class ChangeIntForBigIntToSaleDistpach < ActiveRecord::Migration
  def change
  	change_column :sale_distpaches, :folio, :integer, :limit => 8
  end
end
