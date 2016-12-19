class AddRefToGMovDistpach < ActiveRecord::Migration
  def change
  	add_reference :gmov_distpaches, :saleDistpach,  index: true, foreign_key: true
    add_reference :gmov_distpaches, :user, index: true, foreign_key: true
  end
end
