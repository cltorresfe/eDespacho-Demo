class SearchController < ApplicationController

  def search
  	folio = params[:search][:q].to_s
  	type = params[:search][:type_sale].to_s
    if type == "Gap"
      # show_gaps(folio)
      return
    end
    if type == "Cotiza"
      @cotiza = Quote.find(folio)
      redirect_to edit_quote_path(@cotiza) if @cotiza.state == 1
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
      @cliente_acoma = ClienteAcoma.new
      result_distpach = nil
      if result_distpach.present? 
        mensaje = "Ya existe un despacho con fecha: #{result_distpach.first.created_at}"
        redirect_to root_path, danger: mensaje
        return
      else
        @distpach = new_sale_distpach(@sale, @credit_note )
      end
    else
      if @distpach.cliente_acoma.present?
        @cliente_acoma = @distpach.cliente_acoma
      else
        @cliente_acoma = ClienteAcoma.new
      end
      # @distpach = edit_sale_distpach(@distpach, @sale, @credit_note )
  	end
  rescue ActiveRecord::RecordNotFound
    return	
  end

  def search_distpaches
    @array_data = Array.new
    @array_data << Time.now
    unless current_user.admin? 
     current_user.warehouse.present? ? @array_data << current_user.warehouse.id : @array_data << ''
    end
    @gmov_distpaches_all = GmovDistpach.consulta_cierre_diario(@array_data)
    @gmov_distpaches = @gmov_distpaches_all.paginate(:page => params[:page], :per_page => 20) if @gmov_distpaches_all.present?
    flash.now[:warning] = "No se encontraron resultados para su búsqueda" unless @gmov_distpaches.present?

    respond_to do |format|
      format.html
      format.csv { send_data @prueba.to_csv }
      format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
    end 
  end

  def search_stock_products
    if  params[:term].blank?
      flash.now[:warning] = "Debe seleccionar un producto"
    else
      term = params[:term]
      bodega = current_user.admin? ? params[:store][:CodBode] : current_user.warehouse.id
      @products = Product.where("DesProd LIKE ?", "%#{term}%")
      @products = @products.by_bodega(bodega).sorted.paginate(:page => params[:page], :per_page => 20) if @products.present?
    end
  end

  def search_registro_existencia
    if  params[:term].blank?
      flash.now[:warning] = "Debe seleccionar un producto"
    else
      term = params[:term]
      bodega = current_user.admin? ? params[:store][:CodBode] : current_user.warehouse.id
      @products = Product.where("DesProd LIKE ?", "%#{term}%")
      @products = @products.by_bodega(bodega).sorted.paginate(:page => params[:page], :per_page => 20) if @products.present?
    end
  end

  def search_costs
    if  params[:CodProd].blank?
      flash.now[:warning] = "Debe seleccionar un producto"
    else
      @costos_producto = Costo.where(CodProd: params[:CodProd]).last
      if@costos_producto.present?
        @compra_ventas_producto = Gmov.where(CodProd: params[:CodProd], Actualizado: -1)
        @stock = @compra_ventas_producto.sum(:CantIngresada) - @compra_ventas_producto.sum(:CantDespachada)
        @pending_distpach = GmovDistpach.where("id_product = ? and pending_distpach > 0 ", params[:CodProd]).sum(:pending_distpach)
      else
        flash.now[:warning] = "No existen Costos ingresados para este producto seleccionado: "+params[:CodProd]
      end
    end
    respond_to do |format|
      format.html
      format.pdf { render template: 'search/search_cotizacion', pdf: 'Cotizacion' }
      format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
    end

  end

  def llamada_ajax
    
    @quote = Quote.new(quote_params)
    @quote.user = current_user
    @quote.state = 1
    if @quote.save
      respond_to do |format|
        format.json { render :json => @quote.to_json }
      end
    else
      render action:search_costs
    end
    
  end

  def buscardor_autocomplete
    term = params[:term]
    @find = Product.select("DesProd as value, CodProd").where("DesProd LIKE ?", "%#{term}%").limit(10)
    respond_to do |format|
      format.json { render :json => @find.to_json }
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
    @distpach.subTipoDoc = sale.SubTipoDocto
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

  private
  def quote_params
    params.require(:cotiza).permit(:id_product, :price, :quantity, :margin, :net_price, :total_price, :tax_iva, :cost_product )
  end
end
