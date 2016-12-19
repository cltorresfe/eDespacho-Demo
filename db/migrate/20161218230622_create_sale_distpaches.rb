class CreateSaleDistpaches < ActiveRecord::Migration
  def change
    create_table :sale_distpaches do |t|
      t.string :id_sale_type
      t.integer :id_sale
      t.string :id_store
      t.string :name_seller

      t.timestamps
    end
  end
end
