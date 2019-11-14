class AddFieldnameToGmovDistpach < ActiveRecord::Migration
  def change
    add_column :gmov_distpaches, :observation, :string, default: nil
  end
end
