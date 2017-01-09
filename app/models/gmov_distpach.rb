class GmovDistpach < ActiveRecord::Base
	belongs_to :user
	belongs_to :sale_distpach

	def self.all_by_warehouse(warehouse, start_date, end_date)
		joins(:sale_distpach).where(sale_distpaches: { id_store: warehouse.id} )
		.where(created_at: start_date..end_date)
	end
end
