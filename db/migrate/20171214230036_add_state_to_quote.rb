class AddStateToQuote < ActiveRecord::Migration
  def change
  	add_column :quotes, :state, :integer
  end
end
