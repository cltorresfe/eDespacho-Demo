class ClienteAcoma < ActiveRecord::Base
	belongs_to :user
	has_many :sale_distpaches, dependent: :destroy

	def rut_cliente
	  [run_cliente, dv_cliente].join('-')
	end
end
