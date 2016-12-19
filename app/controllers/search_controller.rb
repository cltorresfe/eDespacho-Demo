class SearchController < ApplicationController

  def search
  	folio = params[:search][:q].to_i
  	type = params[:search][:type_sale].to_s
  	@sale = Sale.folio_sale(type, folio)
  	unless @sale
  	 redirect_to root_path, danger: 'No se encontró una resultado válida para su búsqueda.'
  	end
  	@credit_note = Sale.credit_note('N', folio, type)
  	@distpach = SaleDistpach.find_distpach(type, @sale.NroInt)
  	unless @distpach.present?
  		@distpach = new_sale_distpach(@sale, @credit_note )
  	end
  end

  private

  def new_sale_distpach(sale, credit_note)
  	@distpach = SaleDistpach.new
  	@distpach.id_sale_type = sale.Tipo
  	@distpach.id_sale = sale.NroInt
  	@distpach.id_store = sale.CodBode
  	@distpach.name_seller = sale.Usuario
  	@distpach.save!
  	sale.gmovs.each do |gmov|
  		@gmovDistpach = GmovDistpach.new
  		if credit_note.present?
  			credit_note.gmovs.each do |nc_product|
  			  if(gmov.CodProd == nc_product.CodProd)
  			 		@gmovDistpach.has_credit_note = true
  			 		@gmovDistpach.pending_distpach = gmov.CantFacturada + nc_product.CantFacturada
  			 	else
  			 		@gmovDistpach.pending_distpach = gmov.CantFacturada
  			 	end
  			end
  		end
  		@gmovDistpach.name_product = gmov.DetProd
  		@gmovDistpach.id_product = gmov.CodProd
  		@gmovDistpach.id_line_gmov = gmov.Linea
  		@gmovDistpach.sale_check_quantity = gmov.CantFacturada
  		@gmovDistpach.user = current_user
  		@gmovDistpach.sale_distpach = @distpach
  		@gmovDistpach.save!
  	end
  	return @distpach
  end
end
