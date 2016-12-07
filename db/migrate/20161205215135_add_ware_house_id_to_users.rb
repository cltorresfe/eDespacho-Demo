class AddWareHouseIdToUsers < ActiveRecord::Migration
  def change
  	add_reference :users, :warehouse, index: true, foreign_key: true
  end
end
