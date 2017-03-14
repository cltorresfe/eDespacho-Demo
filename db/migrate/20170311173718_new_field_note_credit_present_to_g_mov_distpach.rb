class NewFieldNoteCreditPresentToGMovDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :credit_notes, :string, default: nil
  end
end
