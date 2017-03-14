class AddFieldBodegaToOpenGuide < ActiveRecord::Migration
  def change
  	add_column :open_guides, :bodega, :integer, default: nil
  end
end
