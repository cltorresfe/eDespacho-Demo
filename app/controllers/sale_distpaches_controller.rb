class SaleDistpachesController < ApplicationController
	def new
	end

	def destroy
		@sale = SaleDistpach.find(params[:id])
		params_search = ActionController::Parameters.new({
			search: {
				q: @sale.folio,
				type_sale: @sale.id_sale_type
			}
		})
		@sale.destroy!
		redirect_to search_path(params_search), action: "search", success: 'Despacho Eliminado satisfactoriamente.'
	end

	def create
		@sale = SaleDistpach.find(sale_distpach_params[:id])
		if Date.today > @sale.fecha_crea_softland && !@sale.cliente_acoma.present?
			params_search = ActionController::Parameters.new({
				search: {
					q: @sale.folio,
					type_sale: @sale.id_sale_type
				}
			})
      redirect_to search_path(params_search), action: "search", danger: 'Debe asociar un cliente para este despacho'
		  return
		end
	  p = params[:sale_distpach][:gmov_distpaches]
		@type_distpach = params[:commit]
		if( @type_distpach == 'Despachar Total')
			@sale.status = "Despachado"
			p.each do |g|
				@gmov = GmovDistpach.find(g[1][:id])
				@gmov.distpached_quantity = @gmov.pending_distpach.to_f + @gmov.distpached_quantity.to_f
				@gmov.pending_distpach = 0
				@gmov.status = "Completado"
				@gmov.fecha_inicia_despacho = Time.now - 3.hours if @gmov.fecha_inicia_despacho == nil
				@gmov.fecha_ultimo_despacho = Time.now - 3.hours
				@gmov.updated_at = Time.now - 3.hours
				@gmov.observation = g[1][:observation] if g[1][:observation] != nil
				@gmov.save!
			end
			@sale.updated_at = Time.now - 3.hours
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
						@gmov.pending_distpach = eval(sprintf("%8.4f",@gmov.pending_distpach))
					else
						@gmov.status = "Error"
					end
				else  
					if (g[1][:distpached_quantity].to_f <= @gmov.pending_distpach.to_f )
						@gmov.distpached_quantity = g[1][:distpached_quantity].to_f
						@gmov.pending_distpach = @gmov.pending_distpach.to_f - g[1][:distpached_quantity].to_f
					else
						@gmov.status = "Error"
					end
				end
				if(@gmov.pending_distpach.to_f < 0)
					@gmov.pending_distpach = 0
				end
				if(@gmov.pending_distpach.to_f <= 0)
					@gmov.user = current_user
					@gmov.fecha_inicia_despacho = Time.now - 3.hours if @gmov.fecha_inicia_despacho == nil
					@gmov.updated_at = Time.now - 3.hours
					@gmov.fecha_ultimo_despacho = Time.now - 3.hours
					@gmov.observation = g[1][:observation] if g[1][:observation] != nil
					@gmov.status = "Completado"
				else
					if(@gmov.pending_distpach.to_f == @gmov.sale_check_quantity.to_f)
						@sale_distpach_complete = false
						@gmov.updated_at = Time.now - 3.hours
					  @gmov.status = "Pendiente"
					  @gmov.observation = g[1][:observation]
					  @gmov.user = current_user
					else
					  @sale_distpach_complete = false
					  @gmov.fecha_inicia_despacho = Time.now - 3.hours if @gmov.fecha_inicia_despacho == nil
					  @gmov.updated_at = Time.now - 3.hours
					  @gmov.fecha_ultimo_despacho = Time.now - 3.hours
					  @gmov.status = "Parcial"
					  @gmov.observation = g[1][:observation]
					  @gmov.user = current_user
				  end
				end
				@gmov.save!
			end
			@sale.status = @sale_distpach_complete ? "Despachado"  : "Pendiente"
			@sale.updated_at = Time.now - 3.hours
			@sale.save!
		end
		params_search = ActionController::Parameters.new({
			search: {
				q: @sale.folio,
				type_sale: @sale.id_sale_type
			}
		}) 

		redirect_to search_path(params_search), action: "search", success: 'Productos Despachados satisfactoriamente.'
		return
	end

	def index
		if  params[:start_date].blank? ||  params[:end_date].blank?
			flash[:warning] = "Debe ingresar una fecha de Inicio y Termino"
		else
			@array_data = Array.new
			@array_data << params[:start_date]
			@array_data << params[:end_date]
			@array_data << params[:id_product]
			@array_data << params[:folio]
			current_user.admin? ? @array_data << params[:warehouse_id][:id] : @array_data << current_user.warehouse.id
			@array_data << params[:status_type]
			@gmov_distpaches_all = GmovDistpach.by_query(@array_data)
			@gmov_distpaches = @gmov_distpaches_all.paginate(:page => params[:page], :per_page => 20) if @gmov_distpaches_all.present?
			flash[:warning] = "No se encontraron resultados para su búsqueda" unless @gmov_distpaches.present?
	  end
	  respond_to do |format|
	  	format.html
	  	format.csv { send_data @prueba.to_csv }
	  	format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
	  end

	end

	private
	def sale_distpach_params
    params.require(:sale_distpach).permit(:id)
	end
end
