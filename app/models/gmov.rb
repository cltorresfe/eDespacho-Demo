class Gmov < ActiveRecord::Base
  establish_connection :report_db_development
  self.table_name_prefix  = 'acoma.softland'
  self.table_name =  "acoma.softland.iw_gmovi"
  self.primary_keys = :Tipo, :NroInt, :Linea
  belongs_to :sale, foreign_key: [:Tipo, :NroInt]
  belongs_to :product, foreign_key: :CodProd
  scope :completados, -> { where(Actualizado: -1) }
  scope :stock, -> { where(Actualizado: -1).sum(:CantIngresada) - sum(:CantDespachada) }

  def self.by_bodega(bodega)
    where('CodBode = ?', bodega)
  end

  def entrada_salida_by_date(fecha, product)
  	Gmov.where('CodProd = ? and Fecha < ? and Actualizado= -1', product, fecha).select('sum(CantIngresada) as ingresos, sum(CantDespachada) as egresos')
  end

  def saldo_by_date(fecha, product)
  	Gmov.where('CodProd = ? and Fecha < ? and Actualizado= -1', product, fecha).select('(sum(CantIngresada) - sum(CantDespachada)) as saldo')
  end

end