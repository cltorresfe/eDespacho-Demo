class Sale < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_gsaen"
  self.primary_keys = :Tipo, :NroInt

  scope :last_sale, -> { where("acoma.softland.iw_gsaen.Total > ?",0).last }
  belongs_to :store, foreign_key: 'CodBode'
  has_many :gmovs, class_name: "Gmov", foreign_key: [:Tipo, :NroInt]

  def self.folio_sale(type, folio)
		where(Folio: folio.to_i, Tipo: type).take
  end

  def self.credit_note(type, folio, doc_ref)
    where(AuxDocNum: folio.to_i, Tipo: type, TipDocRef: doc_ref).take
  end

end