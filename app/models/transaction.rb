class Transaction < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_cocod"
  self.primary_keys = :TipoDoc, :Concepto
end