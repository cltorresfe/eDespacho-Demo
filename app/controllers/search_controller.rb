class SearchController < ApplicationController

  def search
  	folio = params[:search][:q].to_s
  	type = params[:search][:type_sale].to_s
    if type == "Gap"
      $last_folio =0
      str = folio.split("#")
      if(str[1].present?)
        if(is_numerico?(str[0]) && str[0].to_i <101 && str[0].to_i >0 )
          @sales_guia_entradas = Sale.folios_guia_entrada(str[0], $last_folio, str[1])
          @sales_guia_entradas.each do |guide|
            openGuide = OpenGuide.where("folio = ? and bodega = ?", guide.Folio, guide.CodBode )
            unless openGuide.present?
              openGuide = OpenGuide.new 
              openGuide.folio = guide.Folio
              openGuide.bodega = guide.CodBode
              openGuide.save!
            end
          end
          $last_folio = @sales_guia_entradas.last.Folio if (@sales_guia_entradas.present?)    
          @gaps = OpenGuide.where(bodega: str[1].to_i ).folios_gaps(str[0])
        else
          redirect_to root_path, danger: 'La cantidad de resultados de saltos de folio que quiere buscar es incorrecto o muy elevado. Busque un rango de 1 a 100.'
        end
      else
        redirect_to root_path, danger: 'Debe indicar primero la cantidad de resultados que quiere obtener luego un # y posteriormente el código de la bodega. Ejemplo: 20#03'
      end
      return
    end
    folio = params[:search][:q].to_s
  	@sale = Sale.folio_sale(type, folio)
  	unless @sale.present? && @sale.NroInt.present? && ( current_user.admin? || ( current_user.warehouse.present? && current_user.warehouse.id == @sale.CodBode.to_i) )
  	  redirect_to root_path, danger: 'No se encontró un resultado válida para su búsqueda.'
  	  return
  	end
  	@credit_note = Sale.credit_note('N', folio, type)
  	@distpach = SaleDistpach.find_distpach(type, @sale.NroInt)
  	unless @distpach.present?
  		@distpach = new_sale_distpach(@sale, @credit_note )
  	end
  	
  end

  def search_distpaches
    
    
  end

  private

  def is_numerico?(numero)
    return true if Float(numero) rescue false
  end

  def new_sale_distpach(sale, credit_note)
  	@distpach = SaleDistpach.new
  	@distpach.id_sale_type = sale.Tipo
  	@distpach.id_sale = sale.NroInt
  	@distpach.id_store = sale.CodBode.to_i
  	@distpach.name_seller = sale.Usuario
  	@distpach.folio = sale.Folio
  	@flug_sale_distpached = true
  	sale.gmovs.each do |gmov|
  		flug_nc = false
  		@pending = 0.0
      @num_credit_note = ""
  		@gmovDistpach = GmovDistpach.new
  		if credit_note.present?
        credit_note.each do |credit|
    			credit.gmovs.each do |nc_product|
  				  if(gmov.CodProd == nc_product.CodProd)
  						flug_nc = true
   				 		@pending = gmov.CantFactUVta + nc_product.CantFactUVta
              #@num_credit_note = "(#{nc_product.NroInt})"

    			 	end
    			end
        end
  		end
  		unless flug_nc
				@gmovDistpach.pending_distpach = gmov.CantDespUVta
  		else
  			@gmovDistpach.pending_distpach = @pending
  			@gmovDistpach.has_credit_note = true
        @gmovDistpach.credit_notes = @num_credit_note
  		end
  		@gmovDistpach.name_product = gmov.DetProd
      @gmovDistpach.measure = gmov.CodUMed
  		@gmovDistpach.id_product = gmov.CodProd
  		@gmovDistpach.id_line_gmov = gmov.Linea
			@gmovDistpach.sale_check_quantity = gmov.CantDespUVta
  		@gmovDistpach.user = current_user
  		@gmovDistpach.sale_distpach = @distpach
			if(@gmovDistpach.pending_distpach == 0.0)
				@gmovDistpach.status = "Completado"
			else
				@flug_sale_distpached = false
        @gmovDistpach.status = "Pendiente"
			end
  		@distpach.gmov_distpaches << @gmovDistpach
  	end
  	@distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente"
  	@distpach.save!
  	return @distpach
  end
end
