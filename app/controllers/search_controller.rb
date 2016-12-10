class SearchController < ApplicationController
  def search
  	@sale = Sale.folio_sale(params[:search][:q])
  	unless @sale
  	 redirect_to root_path, danger: 'No se encontró un resultado válido para su búsqueda.'	
  	end
      
  end
end
