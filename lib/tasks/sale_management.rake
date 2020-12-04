namespace :gestiona do
  desc "Gestiona las notas de créditos y las ventas de factura y boleta para agregarlas a eDespacho en forma automática"
  task :ventas => :environment do
  	my_logger ||= Logger.new("#{Rails.root}/log/my_management_production_nov_2019.log")
  	7900.times do  		
		  #... content of the loop
		  min = Time.now - 4.hours - 4.minutes
		  my_logger.info("Consultando Rango: #{Time.now - 4.minutes} - #{Time.now} ")
		  puts "Consultando a BD Softland..."
		  products = Sale.all_last_sales_softland(min, Time.now )
		  sleep(1)
  	  puts "Cantidad de Productos encontrados: #{products.length}"
  	  my_logger.info("Cantidad de Productos encontrados: #{products.length}")
  	  if(products.length > 0)
      	products.each do |sale|
      		my_logger.info("(nuevo)...Doc encontrado: #{sale.Tipo} - Folio: #{sale.Folio}. IdSale: #{sale.NroInt}")
      		puts "(nuevo)...Doc encontrado: #{sale.Tipo} - Folio: #{sale.Folio}. IdSale: #{sale.NroInt}"
				  if(sale.Tipo == "N")
				  	my_logger.info("(again)...Doc encontrado: #{sale.Tipo} - Folio: #{sale.Folio}. IdSale: #{sale.NroInt}")
				  	save_credit_note(sale)
				  else
				  	save_sale(sale)
				  end
				  sleep(1)
				end
			end
		  my_logger.info("Esperando para siguiente consulta automática...")
		end
		my_logger.info("#{Time.now} - Tarea Terminada Satisfactoriamente!")
	end
end
def save_sale(sale)
	my_logger ||= Logger.new("#{Rails.root}/log/my_management_production_nov_2019.log")
	# pregunta si existe una factura o boleta ya ingresada a eDespacho
	sleep(1)
	@distpach_edespacho = SaleDistpach.find_distpach(sale.Tipo, sale.NroInt)
	sleep(1)
	unless @distpach_edespacho.present?
		my_logger.info("(nuevo)...Guardando Doc. Tipo: #{sale.Tipo} - Folio: #{sale.Folio}. IdSale: #{sale.NroInt}")
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
			  my_logger.info("Guardando producto #{gmov.CodProd} Cantidad pendiente por despachar: #{gmov.CantDespUVta}")
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
			my_logger.info("ERROR CL-> #{e.message} ... Guardando despacho. Tipo: #{sale.Tipo} - Folio: #{sale.Folio}. IdSale: #{sale.NroInt}")
		end
	end
end

def save_credit_note_product(nc_product, credit_note_softland)
	my_logger ||= Logger.new("#{Rails.root}/log/my_management_production_nov_2019.log")
	# Agrega Nota de crédito a eDespacho
	my_logger.info("(nuevo)...Guardando Nota de Credito - Folio: #{credit_note_softland.Folio}. IdSale: #{credit_note_softland.NroInt}")
	my_logger.info("Guardando producto NC #{nc_product.CodProd} Cantidad pendiente por despachar: #{nc_product.CantFactUVta}")
	@credit = CreditNote.new
	@credit.folio = credit_note_softland.Folio.to_i
	@credit.type_doc = credit_note_softland.Tipo
	@credit.cod_product = nc_product.CodProd
	@credit.quantity = nc_product.CantFactUVta
	@credit.fecha_crea_softland = credit_note_softland.FecHoraCreacion
	begin
		@credit.save!
	rescue Exception => e
		my_logger.info("ERROR CL-> #{e.message} ... Guardando NC despacho. Tipo: #{credit_note_softland.Tipo} - Folio: #{credit_note_softland.Folio}. IdSale: #{credit_note_softland.NroInt}")
	end
	
end

def save_credit_note(credit_note_softland)
	my_logger ||= Logger.new("#{Rails.root}/log/my_management_production_nov_2019.log")
	my_logger.info("nota de credito encontrada: #{credit_note_softland.TipDocRef} - Folio: #{credit_note_softland.AuxDocNum}.")
	# pregunta si existe una nota de credito ya ingresada a eDespacho
	@credit = CreditNote.find_credit_note(credit_note_softland.Tipo, credit_note_softland.Folio.to_i )
	unless @credit.present?
		#recorre los productos con las notas de credito de Softland
		my_logger.info("nota de credito no ingresada")
		credit_note_softland.gmovs.each do |nc_product|
			my_logger.info("productos nota de credito no ingresada #{nc_product.CodProd}")
			@sale_softland = Sale.folio_sale(credit_note_softland.TipDocRef, credit_note_softland.AuxDocNum)
			my_logger.info("Docum asociado a la nota de credito: #{@sale_softland.Tipo} Folio:#{@sale_softland.Folio}")
			if @sale_softland.present? && @sale_softland.NroInt.present?
				my_logger.info("Doc con Nota credito Tipo: #{credit_note_softland.TipDocRef} - Folio: #{credit_note_softland.AuxDocNum}.")
				@distpach = SaleDistpach.find_distpach(@sale_softland.Tipo, @sale_softland.NroInt)
				my_logger.info("tarea 1")
				@flug_sale_distpached = true
				if @distpach.present?
					my_logger.info("Documento existente en eDespacho Tipo: #{@sale_softland.Tipo} Folio:#{@sale_softland.Folio}")
					save_credit_note_product(nc_product, credit_note_softland)
					sleep(1)
					my_logger.info("tarea 3")
					# actualiza SaleDistpach y GmovDistpach rebajando los notas de crédito
		  		@flug_sale_distpached = actualiza_documento_con_nota_de_credito(@distpach, nc_product)
		  		my_logger.info("tarea 7")
		  		@distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente Automatico"
		  		@distpach.updated_at = Time.now - 3.hours
		  		begin
		  			@distpach.save!
		  		rescue Exception => e
		  			my_logger.info("ERROR CL-> #{e.message} ... Guardando NC2 despacho. Tipo: #{credit_note_softland.Tipo} - Folio: #{credit_note_softland.Folio}. IdSale: #{credit_note_softland.NroInt}")
		  		end
		  		sleep(1)
		  		my_logger.info("tarea 8")
		  	else
		  		my_logger.info("No encuentra documento en Softlandy y lo guarda 1")
		  		save_sale(@sale_softland)
		  		sleep(1)
		  		@distpach = SaleDistpach.find_distpach(@sale_softland.Tipo, @sale_softland.NroInt)
		  		if @distpach.present?
					  my_logger.info("Ahora Documento existente en eDespacho Tipo: #{@sale_softland.Tipo} Folio:#{@sale_softland.Folio}")
		  			save_credit_note_product(nc_product, credit_note_softland)
		  			sleep(1)
		  		  @flug_sale_distpached = actualiza_documento_con_nota_de_credito(@distpach, nc_product)
		  		  @distpach.status = @flug_sale_distpached ? "Despachado"  : "Pendiente Automatico"
		  		  my_logger.info("si es false:PendienteAutomatica Si es true:Despachado -> #{@flug_sale_distpached}")
		  		  @distpach.updated_at = Time.now - 3.hours

		  		  begin
		  		  	@distpach.save!
		  		  rescue Exception => e
		  		  	my_logger.info("ERROR CL-> #{e.message} ... Guardando NC3 despacho. Tipo: #{credit_note_softland.Tipo} - Folio: #{credit_note_softland.Folio}. IdSale: #{credit_note_softland.NroInt}")
		  		  end
		  		  sleep(1)
		  		else
		  			my_logger.info("algo anda mal!")
					end

		  	end
	  	end
		end
	end
	my_logger.info("salida 4")
end

def actualiza_documento_con_nota_de_credito(distpach, nc_product)
	my_logger ||= Logger.new("#{Rails.root}/log/my_management_production_nov_2019.log")
	@flug_sale_distpached = true
	distpach.gmov_distpaches.each do |gmov|
		my_logger.info("Está en método: actualiza_documento_con_nota_de_credito() - recorriendo nuevo producto del documento")
		@gmovDistpach = gmov
		if(@gmovDistpach.id_product == nc_product.CodProd)
			my_logger.info("se encontró producto igual al NC catidadNC: #{nc_product.CantFactUVta}")
			my_logger.info("el doc en eDespacho por despachar: #{@gmovDistpach.pending_distpach}")
		  @gmovDistpach.pending_distpach = @gmovDistpach.pending_distpach + (nc_product.CantFactUVta)
		  my_logger.info("descontando cantidad pendiente por despachar en documento: #{@gmovDistpach.pending_distpach}")
		  @gmovDistpach.has_credit_note = true
			if(@gmovDistpach.pending_distpach <= 0.0)
				my_logger.info("status gmov: completado")
				@gmovDistpach.status = "Completado"
			else
				my_logger.info("status gmov: Pendiente Automatico")
				@flug_sale_distpached = false
        @gmovDistpach.status = "Pendiente Automatico"
			end
			@gmovDistpach.updated_at = Time.now - 3.hours
		  @gmovDistpach.save!
		  my_logger.info("flug producto despachado: #{@gmovDistpach.status}")
		else
			@flug_sale_distpached = @gmovDistpach.status == "Completado" ? true : false
		end
	end
	return @flug_sale_distpached
end
