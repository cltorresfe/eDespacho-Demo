class ChangeTypeColumnFechaCreaSoftlandToCreditNote < ActiveRecord::Migration
  def change
  	change_column :credit_notes, :fecha_crea_softland, :datetime
  end
end
