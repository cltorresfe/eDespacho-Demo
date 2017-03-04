require 'win32ole'
require 'prawn/labels'
namespace :imprime do
 desc "Envía a imprimir un documento facturado o boleta"
 task :productos => :environment do
 	names = ["Jordan", "Chris", "Jon", "Mike", "Kelly", "Bob", "Greg"]
 	Prawn::Labels.types = {
 	  "QuarterSheet" => {
 	    "paper_size" => [297, 195.28],
 	    "right_margin"=> 8,
 	    "left_margin"=> 8,
 	    "top_margin"=> 18,
 	    "bottom_margin"=> 10,
 	    "columns"    => 1,
 	    "rows"       => 1
 	}}
 	Prawn::Labels.generate("C:/Bitnami/rubystack/names.pdf", names, :type => "QuarterSheet") do |pdf, name|
 	  pdf.text name
 	end
 	Prawn::Document.generate("C:/Bitnami/rubystack/output.pdf") do
 	  font Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf")
 	  text "Euro €"
 	  font_size(30) do
 	    text_box "With kerning:", :kerning => true, :at => [0, y - 40]
 	    text_box "Without kerning:", :kerning => false, :at => [0, y - 80]
 	    text_box "Tomato", :kerning => true, :at => [250, y - 40]
 	    text_box "Tomato", :kerning => false, :at => [250, y - 80]
 	    text_box "WAR", :kerning => true, :at => [400, y - 40]
 	    text_box "WAR", :kerning => false, :at => [400, y - 80]
 	    text_box "F.", :kerning => true, :at => [500, y - 40]
 	    text_box "F.", :kerning => false, :at => [500, y - 80]
 	  end
 	  move_down 80
 	  string = "What have you done to the space between the characters?"
 	  [-2, -1, 0, 0.5, 1, 2].each do |spacing|
 	    move_down 20
 	    text "#{string} (character_spacing: #{spacing})",
 	  :character_spacing => spacing
 	  end
 	  text "Let's see which is the current font_size: #{font_size.inspect}"
 	  move_down 10
 	  font_size 16
 	  text "Yeah, something bigger!"
 	  move_down 10
 	  font_size(25) { text "Even bigger!" }
 	  move_down 10
 	  text "Back to 16 again."
 	  move_down 10
 	  text "Single line on 20 using the :size option.", :size => 20
 	  move_down 10
 	  text "Back to 16 once more."
 	  move_down 10
 	  font("Courier", :size => 10) do
 	    text "Yeah, using Courier 10 courtesy of the font method."
 	  end
 	  move_down 10
 	  font("Helvetica", :size => 12)
 	  text "Back to normal"
 	end

 	path = Rails.root+ '/public/la_gracia.pdf'

 	FileUtils.mkdir_p(path) unless File.exist?(path)

 	printer = "HP Deskjet F2200 series"
 	shell = WIN32OLE.new('Shell.Application')
 	foxit= "C:/Program Files/Foxit Software/Foxit Reader/FoxitReader.exe"
 	shell.ShellExecute(foxit,"/t \"C:/Bitnami/rubystack/output.pdf\" \"HP Deskjet F2200 series\"")

 	puts "#{Time.now} - Deliver success!"
 end
end