class SearchController < ApplicationController

  def search
  	folio = params[:search][:q].to_s
  	type = params[:search][:type_sale].to_s
    if type == "Gap"
      # show_gaps(folio)
      return
    end
  	@sale = Sale.folio_sale(type, folio)
  	unless @sale.present? && @sale.NroInt.present? && ( current_user.admin? || ( current_user.warehouse.present? && current_user.warehouse.id == @sale.CodBode.to_i) )
  	  redirect_to root_path, danger: 'No se encontró un resultado válida para su búsqueda.'
  	  return
  	end
  	@credit_note = Sale.credit_note('N', folio, type)
  	@distpach = SaleDistpach.find_distpach(type, @sale.NroInt)
  	unless @distpach.present?
  		@distpach = new_sale_distpach(@sale, @credit_note )
    else
      # @distpach = edit_sale_distpach(@distpach, @sale, @credit_note )
  	end
  	
  end

  def search_distpaches
    @array_data = Array.new
    @array_data << Time.now
    current_user.warehouse.present? ? @array_data << current_user.warehouse.id : @array_data << ''
    @gmov_distpaches_all = GmovDistpach.consulta_cierre_diario(@array_data)
    @gmov_distpaches = @gmov_distpaches_all.paginate(:page => params[:page], :per_page => 20) if @gmov_distpaches_all.present?
    flash.now[:warning] = "No se encontraron resultados para su búsqueda" unless @gmov_distpaches.present?

    respond_to do |format|
      format.html
      format.csv { send_data @prueba.to_csv }
      format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
    end
    
  end

  def search_costs
    if  params[:costo].blank?
      flash[:warning] = "Debe ingresar una fecha de Inicio y Termino"
    else
      flash[:warning] = "se encontraron resultados para su búsqueda" 
    end
    respond_to do |format|
      format.html
      format.pdf { render template: 'search/search_cotizacion', pdf: 'Cotizacion' }
      format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
    end

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
    @distpach.fecha_crea_softland = sale.FecHoraCreacion
    @distpach.tipo_ingreso = 'IM'
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
              #guardando nota de credito encontrada
              @credit = CreditNote.new
              @credit.folio = credit.Folio.to_i
              @credit.type_doc = credit.Tipo
              @credit.cod_product = nc_product.CodProd
              @credit.quantity = nc_product.CantFactUVta
              @credit.fecha_crea_softland = credit.FecHoraCreacion
              @credit.save!
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
      @gmovDistpach.created_at = Time.now - 3.hours
      @gmovDistpach.updated_at = Time.now - 3.hours
			if(@gmovDistpach.pending_distpach == 0.0)
				@gmovDistpach.status = "Completado"
			else
				@flug_sale_distpached = false
        @gmovDistpach.status = "Pendiente"
			end
  		@distpach.gmov_distpaches << @gmovDistpach
  	end
    @distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente"
    @distpach.created_at = Time.now - 3.hours
    @distpach.updated_at = Time.now - 3.hours
  	@distpach.save!
  	return @distpach
  end

  def edit_sale_distpach(distpach, sale, credit_note)
    @distpach = distpach
    if(@distpach.tipo_ingreso != nil && @distpach.tipo_ingreso == 'IA')
      @flug_sale_distpached = true
      @distpach.gmov_distpaches.each do |gmov|
        flug_nc = false
        @pending = 0.0
        @num_credit_note = ""
        @gmovDistpach = gmov
        if credit_note.present?
          credit_note.each do |credit|
            credit.gmovs.each do |nc_product|
              @credit = CreditNote.where(folio: sale.Folio.to_i, type_doc: sale.Tipo, cod_product: nc_product.CodProd).take
              unless @credit.present?
                flug_nc = true
                @pending = @pending + nc_product.CantFactUVta
                # Agrega Nota de crédito a eDespacho
                @credit = CreditNote.new
                @credit.folio = sale.Folio.to_i
                @credit.type_doc = sale.Tipo
                @credit.cod_product = nc_product.CodProd
                @credit.quantity = nc_product.CantFactUVta
                @credit.fecha_crea_softland = sale.FecHoraCreacion
              end
            end
          end
        end
        if flug_nc
          @gmovDistpach.pending_distpach = @gmovDistpach.pending_distpach + @pending
          @gmovDistpach.has_credit_note = true
          @gmovDistpach.credit_notes = @num_credit_note
        end
        @gmovDistpach.user = current_user
        if(@gmovDistpach.pending_distpach == 0.0)
          @gmovDistpach.status = "Completado"
        else
          @flug_sale_distpached = false
          @gmovDistpach.status = "Pendiente"
        end
        @gmovDistpach.save!
      end
      @distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente"
      @distpach.save!
    end
    return @distpach
  end

  def show_gaps(folio)
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
  end
end
