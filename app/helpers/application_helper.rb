module ApplicationHelper
	require 'open-uri'
	def show_number_cars!
		if Quote.where(user:current_user).present?
		  cotiza_cantidad = Quote.where(user:current_user).count if Quote.where(user:current_user).present?
		  html = <<-HTML
		    <span class='badge badge-info badge-cl' id='badge_cantidad_carro_cotizacion_top_bar'>
		    #{cotiza_cantidad}
		    </span>
		    HTML
		  html.html_safe
		else
			html = <<-HTML
		    <span class='badge badge-info badge-cl' id='badge_cantidad_carro_cotizacion_top_bar'>
		    0
		    </span>
		    HTML
		  html.html_safe
		end
	end

	def has_quotes?
		return Quote.where(user:current_user).present?
	end
	def wicked_pdf_image_tag_for_public(img, options={})
	  image_tag "file:///#{WickedPdfHelper.root_path.join('public', 'images', img)}", options
	end
end