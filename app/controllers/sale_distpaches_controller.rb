class SaleDistpachesController < ApplicationController
	def new
	end

	def create
		@sale = SaleDistpach.find(sale_distpach_params[:id])
		p = params[:sale_distpach][:gmov_distpaches]
		@type_distpach = params[:commit]
		if( @type_distpach == 'Despachar Total')
			@sale.status = "Despachado"
			p.each do |g|
				@gmov = GmovDistpach.find(g[1][:id])
				@gmov.distpached_quantity = @gmov.pending_distpach.to_f
				@gmov.pending_distpach = 0
				@gmov.status = "Completado"
				@gmov.save!
			end
			@sale.save!
		else
			@sale_distpach_complete = true
			p.each do |g|
				@gmov = GmovDistpach.find(g[1][:id])
				@gmov.status = ""
				if @gmov.distpached_quantity.present?
				  if (g[1][:distpached_quantity].to_f <= @gmov.pending_distpach.to_f )
						@gmov.distpached_quantity += g[1][:distpached_quantity].to_f
						@gmov.pending_distpach = @gmov.pending_distpach.to_f - g[1][:distpached_quantity].to_f
					else
						@gmov.status = "Error"
					end
				else  
					if (g[1][:distpached_quantity].to_i <= @gmov.pending_distpach.to_f )
						@gmov.distpached_quantity = g[1][:distpached_quantity].to_f
						@gmov.pending_distpach = @gmov.pending_distpach.to_f - g[1][:distpached_quantity].to_f
					else
						@gmov.status = "Error"
					end
				end
				if(@gmov.pending_distpach.to_f == 0)
					@gmov.status = "Completado"
				else
					@sale_distpach_complete = false
				end
				@gmov.save!
			end
			@sale.status = @sale_distpach_complete ? "Despachado"  : "pendiente"
			@sale.save!
		end
		params_search = ActionController::Parameters.new({
			search: {
				q: @sale.folio,
				type_sale: @sale.id_sale_type
			}
		}) 

		redirect_to search_path(params_search), action: "search", success: 'Productos Despachados satisfactoriamente.'
	end

	def index
		if params[:start_date]
			start_date = params[:start_date].to_date.beginning_of_day
			end_date = params[:end_date].to_date.end_of_day
			@gmov_distpaches = GmovDistpach.where(:created_at => start_date..end_date).paginate(:page => params[:page], :per_page => 10)
		end
	end

	private
	def sale_distpach_params
    params.require(:sale_distpach).permit(:id)
	end
end
