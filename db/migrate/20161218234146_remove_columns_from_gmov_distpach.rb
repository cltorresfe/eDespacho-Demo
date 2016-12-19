class RemoveColumnsFromGmovDistpach < ActiveRecord::Migration
  def change
  	 remove_column :gmov_distpaches, :store_name, :string
  	 remove_column :gmov_distpaches, :name_seller, :string
  end
end
