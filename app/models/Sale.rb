class Sale < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_gsaen"
  self.primary_keys = :Tipo, :NroInt

  scope :last_sale, -> { where("acoma.softland.iw_gsaen.Total > ?",0).last  }
  belongs_to :store, foreign_key: 'CodBode'
  belongs_to :seller, foreign_key: 'CodVendedor'
  belongs_to :auxiPerson, class_name: "AuxiPerson", foreign_key: :CodAux
  belongs_to :transaccion, class_name: 'Transaction', foreign_key: [:Tipo, :Concepto]
  has_many :gmovs, class_name: "Gmov", foreign_key: [:Tipo, :NroInt]

  def self.folio_sale(type, folio)
		where(Folio: folio.to_i, Tipo: type).take
  end

  def self.credit_note(type, folio, doc_ref)
    where(AuxDocNum: folio.to_i, Tipo: type, TipDocRef: doc_ref)
  end

  def self.last_products(hora_i, hora_f, bodega)
    where("acoma.softland.iw_gsaen.FecHoraCreacion >= ? AND acoma.softland.iw_gsaen.FecHoraCreacion <= ? 
      AND (acoma.softland.iw_gsaen.CodBode = ? 
      AND (acoma.softland.iw_gsaen.Tipo = 'F' OR acoma.softland.iw_gsaen.Tipo = 'B' ) AND acoma.softland.iw_gsaen.Folio > 0 )",hora_i,hora_f, bodega)
  end

  def self.all_last_sales_softland(hora_i, hora_f)
    where("acoma.softland.iw_gsaen.FecHoraCreacion >= ? AND acoma.softland.iw_gsaen.FecHoraCreacion <= ? 
      AND (acoma.softland.iw_gsaen.Tipo = 'F' OR acoma.softland.iw_gsaen.Tipo = 'B'  OR acoma.softland.iw_gsaen.Tipo = 'N') AND acoma.softland.iw_gsaen.Folio > 0 ",hora_i,hora_f)
  end

  def self.folios_gaps(cantidad)
    select("(Folio + 1) as Folio").
    where("Tipo = 'E' and NOT EXISTS
        (
        SELECT  NULL
        FROM    acoma.softland.iw_gsaen mi 
        WHERE   mi.Tipo = 'E' and mi.Folio = acoma.softland.iw_gsaen.Folio + 1
        )").first(cantidad)
  end

  def self.folios_guia_entrada(cantidad, last_folio, bodega)
    select("Folio, CodBode").
    where("acoma.softland.iw_gsaen.Folio > ? and acoma.softland.iw_gsaen.CodBode = ? and acoma.softland.iw_gsaen.Tipo = 'E'", last_folio, bodega)
  end


end