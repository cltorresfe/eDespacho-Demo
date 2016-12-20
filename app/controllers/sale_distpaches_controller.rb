class SaleDistpachesController < ApplicationController
	def new
	end

	def create
		@sale = SaleDistpach.find(sale_distpach_params[:id])

		p = params[:sale_distpach][:gmov_distpaches]
		p.each do |g|
			@gmov = GmovDistpach.find(g[1][:id])
			if @gmov.distpached_quantity.present?
			  if (g[1][:distpached_quantity].to_i <= @gmov.pending_distpach.to_i )
					@gmov.distpached_quantity += g[1][:distpached_quantity].to_i
					@gmov.pending_distpach = @gmov.pending_distpach.to_i - g[1][:distpached_quantity].to_i
					@gmov.save!
				end
			else  
				if (g[1][:distpached_quantity].to_i <= @gmov.pending_distpach.to_i )
					@gmov.distpached_quantity = g[1][:distpached_quantity].to_i
					@gmov.pending_distpach = @gmov.pending_distpach.to_i - g[1][:distpached_quantity].to_i
					@gmov.save!
				end
			end
		end
		params_search = ActionController::Parameters.new({
			search: {
				q: @sale.folio,
				type_sale: @sale.id_sale_type
			}
		}) 

		redirect_to search_path(params_search), action: "search", success: 'Productos Despachados satisfactoriamente.'
	end

	private
	def sale_distpach_params
    params.require(:sale_distpach).permit(:id)
	end
end
