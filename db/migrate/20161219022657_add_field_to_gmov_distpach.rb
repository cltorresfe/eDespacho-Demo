class AddFieldToGmovDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :name_product, :string, default: nil
  end
end
