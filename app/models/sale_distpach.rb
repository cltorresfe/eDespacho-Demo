class SaleDistpach < ActiveRecord::Base
	has_many :gmov_distpaches, dependent: :destroy
	validates :folio, :uniqueness => {:scope => [:id_sale_type, :subTipoDoc]}
	belongs_to :cliente_acoma

  def self.find_distpach(type, id_sale)
		where(id_sale_type: type.to_s, id_sale: id_sale).take
  end
  
end
