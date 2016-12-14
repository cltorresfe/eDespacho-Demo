class SearchController < ApplicationController

  def search
  	@sale = Sale.folio_sale(params[:search][:type_sale].to_s, params[:search][:q].to_i)
  	unless @sale
  	 redirect_to root_path, danger: 'No se encontró una boleta válida para su búsqueda.'
  	end
  end

end
