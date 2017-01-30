class AddCodUMedColumnToGmovDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :measure, :string, default: ""
  end
end
