namespace :gestiona_pas do
  desc "Gestiona las notas de créditos y las ventas de factura y boleta para agregarlas a eDespacho en forma automática"
  task :ventas => :environment do
  		
	  #... content of the loop
	  min = Time.now - 29.days
	  puts "Consultando a BD Softland..."
	  products = Sale.all_last_sales_softland(min, Time.now - 4.hours )
	  sleep(1)
  	  puts "Cantidad de Productos encontrados: #{products.length}"
  	  if(products.length > 0)
      	products.each do |sale|
      		puts "(nuevo)...Doc encontrado: #{sale.Tipo} - Folio: #{sale.Folio}. IdSale: #{sale.NroInt}"
				  if(sale.Tipo == "N")
				  	save_credit_note(sale)
				  else
				  	save_sale(sale)
				  end
				  sleep(1)
				end
			end
		end
end
def save_sale(sale)
	# pregunta si existe una factura o boleta ya ingresada a eDespacho
	sleep(1)
	@distpach_edespacho = SaleDistpach.find_distpach(sale.Tipo, sale.NroInt)
	sleep(1)
	unless @distpach_edespacho.present?
		@distpach = SaleDistpach.new
		@distpach.id_sale_type = sale.Tipo
		@distpach.id_sale = sale.NroInt
		@distpach.id_store = sale.CodBode.to_i
		@distpach.folio = sale.Folio
		@distpach.status = "Pendiente Automatico"
		@distpach.subTipoDoc = sale.SubTipoDocto
		@distpach.tipo_ingreso = 'IA'
		begin
			sale.gmovs.each do |gmov|
				@gmovDistpach = GmovDistpach.new
				@gmovDistpach.pending_distpach = gmov.CantDespUVta
				@gmovDistpach.name_product = gmov.DetProd
		    @gmovDistpach.measure = gmov.CodUMed
				@gmovDistpach.id_product = gmov.CodProd
				@gmovDistpach.id_line_gmov = gmov.Linea
				@gmovDistpach.sale_check_quantity = gmov.CantDespUVta
				@gmovDistpach.sale_distpach = @distpach
				@gmovDistpach.created_at = Time.now - 3.hours
				@gmovDistpach.updated_at = Time.now - 3.hours
				if(@gmovDistpach.pending_distpach == 0.0)
					@gmovDistpach.status = "Completado"
				else
					@flug_sale_distpached = false
		      @gmovDistpach.status = "Pendiente Automatico"
				end
				@distpach.gmov_distpaches << @gmovDistpach
			end
			@distpach.fecha_crea_softland = sale.FecHoraCreacion
			@distpach.created_at = Time.now - 3.hours
			@distpach.save!
		rescue Exception => e
		end
	end
end

def save_credit_note_product(nc_product, credit_note_softland)
	# Agrega Nota de crédito a eDespacho
	@credit = CreditNote.new
	@credit.folio = credit_note_softland.Folio.to_i
	@credit.type_doc = credit_note_softland.Tipo
	@credit.cod_product = nc_product.CodProd
	@credit.quantity = nc_product.CantFactUVta
	@credit.fecha_crea_softland = credit_note_softland.FecHoraCreacion
	begin
		@credit.save!
	rescue Exception => e
	end
	
end

def save_credit_note(credit_note_softland)
	# pregunta si existe una nota de credito ya ingresada a eDespacho
	@credit = CreditNote.find_credit_note(credit_note_softland.Tipo, credit_note_softland.Folio.to_i )
	unless @credit.present?
		#recorre los productos con las notas de credito de Softland
		credit_note_softland.gmovs.each do |nc_product|
			@sale_softland = Sale.folio_sale(credit_note_softland.TipDocRef, credit_note_softland.AuxDocNum)
			if @sale_softland.present? && @sale_softland.NroInt.present?
				@distpach = SaleDistpach.find_distpach(@sale_softland.Tipo, @sale_softland.NroInt)
				@flug_sale_distpached = true
				if @distpach.present?
					save_credit_note_product(nc_product, credit_note_softland)
					sleep(1)
					# actualiza SaleDistpach y GmovDistpach rebajando los notas de crédito
		  		@flug_sale_distpached = actualiza_documento_con_nota_de_credito(@distpach, nc_product)
		  		@distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente Automatico"
		  		@distpach.updated_at = Time.now - 3.hours
		  		begin
		  			@distpach.save!
		  		rescue Exception => e
		  		end
		  		sleep(1)
		  	else
		  		save_sale(@sale_softland)
		  		sleep(1)
		  		@distpach = SaleDistpach.find_distpach(@sale_softland.Tipo, @sale_softland.NroInt)
		  		if @distpach.present?
		  			save_credit_note_product(nc_product, credit_note_softland)
		  			sleep(1)
		  		  @flug_sale_distpached = actualiza_documento_con_nota_de_credito(@distpach, nc_product)
		  		  @distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente Automatico"
		  		  @distpach.updated_at = Time.now - 3.hours

		  		  begin
		  		  	@distpach.save!
		  		  rescue Exception => e
		  		  end
		  		  sleep(1)
		  		else
					end

		  	end
	  	end
		end
	end
end

def actualiza_documento_con_nota_de_credito(distpach, nc_product)
	@flug_sale_distpached = true
	distpach.gmov_distpaches.each do |gmov|
		@gmovDistpach = gmov
		if(@gmovDistpach.id_product == nc_product.CodProd)
		  @gmovDistpach.pending_distpach = @gmovDistpach.pending_distpach + (nc_product.CantFactUVta)
		  @gmovDistpach.has_credit_note = true
			if(@gmovDistpach.pending_distpach <= 0.0)
				@gmovDistpach.status = "Completado"
			else
				@flug_sale_distpached = false
        @gmovDistpach.status = "Pendiente Automatico"
			end
			@gmovDistpach.updated_at = Time.now - 3.hours
		  @gmovDistpach.save!
		else
			@flug_sale_distpached = @gmovDistpach.status == "Completado" ? true : false
		end
	end
	return @flug_sale_distpached
end
