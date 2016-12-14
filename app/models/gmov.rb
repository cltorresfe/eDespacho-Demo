class Gmov < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_gmovi"
  self.primary_keys = :Tipo, :NroInt, :Linea
  belongs_to :sale, foreign_key: [:Tipo, :NroInt]

end