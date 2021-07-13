class ChangeIntToBigint < ActiveRecord::Migration
  def change
  	change_column :printers, :folio, :bigint
  end
end
