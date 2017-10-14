class Costo < ActiveRecord::Base
	 establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_costop"
  self.primary_keys = :CodProd, :Fecha
  belongs_to :product, foreign_key: 'CodProd'

end