class AddFolioToSaleDistpach < ActiveRecord::Migration
  def change
  	add_column :sale_distpaches, :folio, :integer, default: nil
  end
end
