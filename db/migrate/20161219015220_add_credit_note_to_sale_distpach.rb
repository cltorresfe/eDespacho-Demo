class AddCreditNoteToSaleDistpach < ActiveRecord::Migration
  def change
  	add_column :gmov_distpaches, :has_credit_note, :boolean, default: false
  end
end
