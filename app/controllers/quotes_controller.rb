class QuotesController < ApplicationController
	before_action :authenticate_user!
  def carro_cotizacion
  	@cotizaciones = Quote.where(user: current_user)
  	@rut_cliente = params[:rut_cliente]
  	@nombre_cliente = params[:nombre_cliente]
  	@direccion_cliente = params[:direccion_cliente]
  	respond_to do |format|
  	  format.html
  	  format.pdf { render template: 'quotes/carro_cotizacion', pdf: 'Cotizacion Cliente' }
  	  format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
  	end
  end

end