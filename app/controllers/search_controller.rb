class SearchController < ApplicationController

  def search
  	folio = params[:search][:q].to_i
  	type = params[:search][:type_sale].to_s
  	@sale = Sale.folio_sale(type, folio)
  	unless @sale
  	 redirect_to root_path, danger: 'No se encontró una boleta válida para su búsqueda.'
  	end
  	@credit_note = Sale.credit_note('N', folio, type)
  end

end
