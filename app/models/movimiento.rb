class Movimiento < ActiveRecord::Base
  establish_connection :report_db_development
  self.abstract_class = true
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.IW_MovimStock"
end