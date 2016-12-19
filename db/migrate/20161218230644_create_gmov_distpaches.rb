class CreateGmovDistpaches < ActiveRecord::Migration
  def change
    create_table :gmov_distpaches do |t|
      t.string :id_product
      t.string :store_name
      t.string :name_seller
      t.integer :id_line_gmov
      t.integer :distpached_quantity
      t.integer :pending_distpach
      t.integer :sale_check_quantity

      t.timestamps
    end
  end
end
