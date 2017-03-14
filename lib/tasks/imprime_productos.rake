require 'win32ole'
require 'prawn/labels'
namespace :imprime do
  desc "Envía a imprimir un documento facturado o boleta"
  task :productos => :environment do
  	products = Sale.last_products(260.minutes.ago, Time.now )
  	puts "#{Time.now} - Deliver success! atras: #{260.minutes.ago}"
  	Prawn::Labels.types = {
	 	  "QuarterSheet" => {
	 	    "paper_size" => [217, 235.28],
	 	    "right_margin"=> 8,
	 	    "left_margin"=> 8,
	 	    "top_margin"=> 18,
	 	    "bottom_margin"=> 10,
	 	    "columns"    => 1,
	 	    "rows"       => 1
	 	}}
	 	puts "cuanto mide el producto: #{products.length}"

	 	if(products.length > 0)
		 	Prawn::Labels.generate("C:/eDespacho/output.pdf", products, :type => "QuarterSheet") do |pdf, sale|
		 	  pdf.font Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf")
	 	    pdf.font_size 5
	 	    pdf.text "eDespacho Software - Productos Acoma"
	 	    pdf.text "#{sale.store.DesBode}"
	 	    pdf.font_size 3
	 	    pdf.text "_________________________________________________________________________________________________________________"
	 	    pdf.font_size 6
	 	    pdf.move_down 5
	 	    pdf.text "Tipo Doc: #{sale.Tipo}                      Folio:#{sale.Folio}"
	 	    pdf.text "Fecha: #{sale.FecHoraCreacion.strftime('%d/%m/%Y')}         Hora: #{sale.FecHoraCreacion.strftime('%I:%M%p')}"
	 	    pdf.text "Caja:#{sale.CodCaja}"
	 	    pdf.text "Vendedor:#{sale.seller.VenDes}"
	 	    pdf.move_down 5
	 	    sale.gmovs.each do |g|
	 	    	pdf.text "-------------- Código Producto: #{g.CodProd}"
	 	    	pdf.text "Medida: #{g.CodUMed}                       Cantidad: #{g.CantDespUVta}"
	 	    	pdf.text "Producto: #{g.DetProd}"
	 	    	pdf.move_down 5
	 	    end
	 	    pdf.text "-------------------------------------------------------------------"
	 	    pdf.font_size 5
	 	    pdf.text "Fecha Imprime: #{Time.now.strftime('%d/%m/%Y Hora: %I:%M%p')}"
	 	    pdf.font_size 3
	 	    pdf.text "SaM Software - Soluciones a la Medida"
		 	end
		 	printer = "HP Deskjet F2200 series"
	 	  shell = WIN32OLE.new('Shell.Application')
	 	  foxit= "C:/Program Files (x86)/Foxit Software/Foxit Reader/FoxitReader.exe"
	 	  #shell.ShellExecute(foxit,"/t \"C:/eDespacho/output.pdf\" \"Brother HL-L5100DN series\"")
		 end

	 	

	 	puts "#{Time.now} - Deliver success!"
	end
end
