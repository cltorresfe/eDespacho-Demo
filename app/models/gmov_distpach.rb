class GmovDistpach < ActiveRecord::Base
	belongs_to :user
	belongs_to :sale_distpach

	def self.by_query(data)
		distpach = all
		distpach = distpach.where(status: data[5]) unless data[5].blank?
		distpach = distpach.where(created_at: data[0].to_date.beginning_of_day..data[1].to_date.end_of_day)  unless data[0].blank? ||  data[1].blank?
		distpach = distpach.where(id_product: data[2]) unless data[2].blank?
		distpach = distpach.joins(:sale_distpach).where(sale_distpaches: { folio: data[3]} ) unless data[3].blank?
		distpach = distpach.joins(:sale_distpach).where(sale_distpaches: { id_store: data[4]} ) unless data[4].blank?
		distpach
	end
	def self.consulta_cierre_diario(data)
		distpach = all
		distpach = distpach.where("fecha_ultimo_despacho between ? and ? OR (fecha_ultimo_despacho is null and created_at between ? and ?)",data[0].to_date.beginning_of_day,data[0].to_date.end_of_day,data[0].to_date.beginning_of_day,data[0].to_date.end_of_day )
		distpach = distpach.joins(:sale_distpach).where(sale_distpaches: { id_store: data[1]} ) unless data[1].blank?
		distpach
	end

	def self.to_csv(options = {})
  	CSV.generate(options) do |csv|
  		csv << column_names
  		all.each do |distpach|
  			csv << distpach.attributes.values_at(*column_names)
  		end
  	end
  end

end
