class QuotesController < ApplicationController
	before_action :authenticate_user!
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  def carro_cotizacion
  	@cotizaciones = Quote.where(user: current_user)
  	@rut_cliente = params[:rut_cliente]
  	@nombre_cliente = params[:nombre_cliente]
  	@direccion_cliente = params[:direccion_cliente]
    if params[:rut_cliente].present?
      @customer_quote = CustomerQuote.new
      @customer_quote.address = params[:direccion_cliente]
      @customer_quote.full_name = params[:nombre_cliente]
      @customer_quote.rut = params[:rut_cliente]
      @customer_quote.total_quote = @cotizaciones.sum(:total_price) if @cotizaciones.present?
      @customer_quote.save!
    end
    flash.now[:warning] = "No se encontraron resultados para su búsqueda" unless @cotizaciones.present?
  	respond_to do |format|
  	  format.html
  	  format.pdf { render template: 'quotes/carro_cotizacion', pdf: 'Cotizacion Cliente' }
  	  format.xls # { send_data @prueba.to_csv(col_sep: "\t") }
  	end
  end
  def destroy
    @quote.destroy
    @cotizaciones = Quote.where(user: current_user)
    respond_to do |format|
      format.html { redirect_to carro_cotizacion_path }
    end
  end
  def show
  end
  def edit
  end
  def update
    respond_to do |format|
      if @quote.update_attributes(quote_params)
        format.html { redirect_to @quote, notice: 'Item de Cotizacion ha sido actualizada correctamente' }
      else
        format.html { render action: "edit" }
      end
    end
  end
  private
  def quote_params
    params.require(:quote).permit(:id_product, :price, :quantity, :margin, :net_price, :total_price, :tax_iva, :cost_product )
  end
  def set_quote
    @quote = Quote.find(params[:id])
  end

end