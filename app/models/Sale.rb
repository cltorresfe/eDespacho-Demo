class Sale < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_gsaen"
  self.primary_key = "NroInt"

  scope :last_sale, -> { where("acoma.softland.iw_gsaen.Total > ?",0).last }
  belongs_to :store, foreign_key: 'CodBode'

  def self.folio_sale(folio)
		where(Folio: folio.to_i).take
  end

end