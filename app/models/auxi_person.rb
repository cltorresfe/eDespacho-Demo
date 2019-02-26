class AuxiPerson < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.cwtauxi"
  self.primary_key = :CodAux
end