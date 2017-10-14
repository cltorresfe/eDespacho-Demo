class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.references :user, index: true
      t.string :id_product
      t.integer :price
      t.integer :quantity
      t.float :margin
      t.integer :net_price

      t.timestamps
    end
  end
end
