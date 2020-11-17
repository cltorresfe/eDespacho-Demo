class AddRefToUser < ActiveRecord::Migration
  def change
  	add_reference :clientes, :user, index: true, foreign_key: true
  end
end
