class AddColumnStatusToSaleDistpach < ActiveRecord::Migration
  def change
  	add_column :sale_distpaches, :status, :string, default: nil
  end
end
