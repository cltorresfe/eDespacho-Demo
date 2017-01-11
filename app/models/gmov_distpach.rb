class GmovDistpach < ActiveRecord::Base
	belongs_to :user
	belongs_to :sale_distpach

	def self.by_query(data)
		distpach = all
		distpach = distpach.where(status: data[4]) unless data[4].blank?
		distpach = distpach.where(created_at: data[0].to_date.beginning_of_day..data[1].to_date.end_of_day)  unless data[0].blank? ||  data[1].blank?
		distpach = distpach.where(id_product: data[2]) unless data[2].blank?
		distpach = distpach.joins(:sale_distpach).where(sale_distpaches: { id_store: data[3]} ) unless data[3].blank?
		distpach
	end

end
