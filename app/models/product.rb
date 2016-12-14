class Product < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_tprod"
  self.primary_key = :CodProd
  belongs_to :gmov, foreign_key: :CodProd

end