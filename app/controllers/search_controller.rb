class SearchController < ApplicationController

  def search
  	folio = params[:search][:q].to_i
  	type = params[:search][:type_sale].to_s
  	@sale = Sale.folio_sale(type, folio)
  	unless @sale.present? && @sale.NroInt.present?
  	  redirect_to root_path, danger: 'No se encontró una resultado válida para su búsqueda.'
  	  return
  	end
  	@credit_note = Sale.credit_note('N', folio, type)
  	@distpach = SaleDistpach.find_distpach(type, @sale.NroInt)
  	unless @distpach.present?
  		@distpach = new_sale_distpach(@sale, @credit_note )
  	end
  	
  end

  def search_distpaches
    @gmov_distpaches = GmovDistpach.paginate(:page => params[:page], :per_page => 10)
    
  end

  private

  def new_sale_distpach(sale, credit_note)
  	@distpach = SaleDistpach.new
  	@distpach.id_sale_type = sale.Tipo
  	@distpach.id_sale = sale.NroInt
  	@distpach.id_store = sale.CodBode
  	@distpach.name_seller = sale.Usuario
  	@distpach.folio = sale.Folio
  	@flug_sale_distpached = true
  	sale.gmovs.each do |gmov|
  		flug_nc = false
  		@pending = 0.0
  		@gmovDistpach = GmovDistpach.new
  		if credit_note.present?
  			credit_note.gmovs.each do |nc_product|
				if(gmov.CodProd == nc_product.CodProd)
						flug_nc = true
 				 		@pending = gmov.CantFacturada + nc_product.CantFacturada
  			 	end
  			end
  		end
  		unless flug_nc
				@gmovDistpach.pending_distpach = gmov.CantFacturada
  		else
  			@gmovDistpach.pending_distpach = @pending
  			@gmovDistpach.has_credit_note = true
  		end
  		@gmovDistpach.name_product = gmov.DetProd
  		@gmovDistpach.id_product = gmov.CodProd
  		@gmovDistpach.id_line_gmov = gmov.Linea
			@gmovDistpach.sale_check_quantity = gmov.CantFacturada
  		@gmovDistpach.user = current_user
  		@gmovDistpach.sale_distpach = @distpach
			if(@gmovDistpach.pending_distpach == 0.0)
				@gmovDistpach.status = "Completado"
			else
				@flug_sale_distpached = false
			end
  		@distpach.gmov_distpaches << @gmovDistpach
  	end
  	@distpach.status = @flug_sale_distpached ? "Despachado"  : "pendiente"
  	@distpach.save!
  	return @distpach
  end
end
