class AddStatusToGmovDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :status, :string, default: nil
  end
end
