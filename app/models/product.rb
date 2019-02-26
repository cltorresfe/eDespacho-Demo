class Product < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_tprod"
  self.primary_key = :CodProd

  belongs_to :gmov, foreign_key: :CodProd
  has_many :costos, class_name: "Costo", foreign_key: :CodProd
  has_many :gmovs, class_name: "Gmov", foreign_key: :CodProd

  scope :sorted, -> { order(DesProd: :asc) }

  def self.by_bodega(bodega)
  	where( Gmov.by_bodega(bodega).where("iw_tprod.CodProd = iw_gmovi.CodProd").exists )
  end
end