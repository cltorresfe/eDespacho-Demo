require 'win32ole'
require 'prawn/labels'
require 'prawn/table'
namespace :imprime do
  desc "Envía a imprimir un documento facturado o boleta"
  task :productos => :environment do
  	min = Time.now - 4.hours - 3.minutes
  	puts "#{Time.now} - Deliver success! atras: #{Time.now - 3.minutes}"
  	products = Sale.last_products(min, Time.now )
  	products_within_print = []
  	page_size = 0
  	products.each do |sale|
  		printer = Printer.where(folio: sale.Folio, id_gsaen: sale.NroInt).take
  		if( printer.present?)
  			printer.destroy
  		else
	  		printer = Printer.new
	  		printer.folio = sale.Folio
	  		printer.id_gsaen = sale.NroInt
	  		printer.type_doc = sale.Tipo
	  		printer.codigo_bodega = sale.CodBode
	  		printer.imprime_at = 1.minutes.ago
  			printer.save!
  			products_within_print << sale
  		end
  	end
  	products_within_print.each do |sale|
  		page_size = page_size + 100 #encabezado pdf
  		sale.gmovs.each do |g|
  			page_size = page_size + 13 #productos
  		end
  		page_size = page_size + 20 #pie de página
  	end
  	page_size = page_size + 18 #para el ok
  	if(products_within_print.length > 0)
		 	puts "Cantidad de Productos  Imprimir: #{products_within_print.length}"
		 	if page_size > 774
		 		pdf = Prawn::Document.new(:page_size => [200, 774], :margin => [5,5,5,5]) 
		 	else
		 		page_size = page_size + 18 #para el ok
		 		pdf = Prawn::Document.new(:page_size => [200, page_size], :margin => [5,5,5,5])
		 	end
		 	products_within_print.each do |sale|
		 	  pdf.font "Times-Roman"
	 	    pdf.font_size 7
	 	    pdf.text "eDespacho Software - Productos Acoma Ltda.", align: :center
	 	    pdf.text "#{sale.store.DesBode}", align: :center
	 	    pdf.font_size 3
	 	    pdf.stroke_horizontal_rule
	 	    pdf.font_size 8
	 	    pdf.move_down 5
	 	    pdf.text "Tipo Doc: #{sale.Tipo}                          Folio:#{sale.Folio}"
	 	    pdf.text "Fecha: #{sale.FecHoraCreacion.strftime('%d/%m/%Y')}                 Hora: #{sale.FecHoraCreacion.strftime('%I:%M%p')}"
	 	    pdf.text "Caja:#{sale.CodCaja}"
	 	    pdf.text "Vendedor:#{sale.seller.VenDes}" if sale.seller.present?
	 	    pdf.move_down 5
	 	    data = []
	 	    data  << ["COD", "UM","Q", "PRODUCTO"]
	 	    sale.gmovs.each do |g|
	 	    	data << [g.CodProd, g.CodUMed, g.CantDespUVta, g.DetProd]
	 	    end
	 	    pdf.font_size 7
	 	    pdf.table(data, { :position => :center }) do
	 	    	row(0).font_style = :bold
	 	    	column(0).width = 35
	 	    	column(1).width = 20
	 	    	column(1).style(:align => :center)
	 	    	column(2).width = 20
	 	    	column(2).style(:align => :center)
	 	    	row(0).style(:align => :center)
	 	      cells.padding = 1
	 	      cells.borders = []
	 	      row(0).font_size = 6
	 	      row(0).borders      = [:bottom]
	 	      row(0).border_width = 0.5
	 	      row(-1).border_width = 0.5
	 	      row(-1).borders = [:bottom]
	 	    end
	 	    pdf.move_down 5
	 	    pdf.font_size 6
	 	    pdf.text "Fecha Imprime: #{Time.now.strftime('%d/%m/%Y Hora: %I:%M%p')}", align: :center
		 	end
		 	pdf.move_down 85
		 	pdf.text "\r \n"+"p:"+page_size.to_s
		 	pdf.render_file "C:/eDespacho/output.pdf"
			printer = '\\Bodega_51/BIXOLON SRP-350II (Copiar 1)'
		 	shell = WIN32OLE.new('Shell.Application')
		 	foxit= "C:/Program Files (x86)/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe"
		 	shell.ShellExecute(foxit,"/t \"C:/eDespacho/output.pdf\"")
		 	puts "Documento enviado a impresora"
		 	puts "#{Time.now} - Deliver success!"
		 end
	end
end
