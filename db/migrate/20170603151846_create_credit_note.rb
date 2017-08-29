class CreateCreditNote < ActiveRecord::Migration
  def change
    create_table :credit_notes do |t|
    	t.integer :folio
    	t.string :type_doc
    end
  end
end
