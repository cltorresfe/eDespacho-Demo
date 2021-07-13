

class ClienteAcomasController < ApplicationController
  before_action :set_cliente_acoma, only: [:show, :edit, :update, :destroy]

  def index
    @cliente_acomas = ClienteAcoma.all
    @cliente_acoma = ClienteAcoma.new
  end

  def show
  end

  def new
    @cliente_acoma = ClienteAcoma.new
  end

  def edit
  end

  # POST /cliente_acomas
  # POST /cliente_acomas.js
  def create
    if params[:id_cliente_acoma].present?
      cliente_cl = params[:id_cliente_acoma]
      @cliente_acoma = ClienteAcoma.find(params[:id_cliente_acoma])

      respond_to do |format|
        if @cliente_acoma.update(cliente_acoma_params)
          rut_cliente = params[:buscador_rut_cliente].split('-')
          @cliente_acoma.run_cliente = rut_cliente[0]
          @cliente_acoma.dv_cliente = rut_cliente[1]
          @cliente_acoma.user = current_user
          @cliente_acoma.save!
          asocia_cliente_despacho(@cliente_acoma)
          format.html { redirect_to @cliente_acoma, notice: 'Cliente acoma ha sido actualizado correctamente.' }
          format.js
        else
          format.html { render action: 'edit' }
          format.js
        end
      end
    else
     @cliente_acoma = ClienteAcoma.new(cliente_acoma_params)
     rut_cliente = params[:buscador_rut_cliente].split('-')
     @cliente_acoma.user = current_user
     @cliente_acoma.run_cliente = rut_cliente[0]
     @cliente_acoma.dv_cliente = rut_cliente[1]

     respond_to do |format|
      if @cliente_acoma.save
        asocia_cliente_despacho(@cliente_acoma)
        format.html { redirect_to @cliente_acoma, notice: 'Cliente acoma ha sido creado correctamente.' }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
     end
    end
  end
  # PUT /cliente_acomas/1
  # PUT /cliente_acomas/1.json
  def update
    if params[:id_cliente_acoma].present?
      @cliente_acoma = ClienteAcoma.find(params[:id_cliente_acoma])
      respond_to do |format|
        if @cliente_acoma.update(cliente_acoma_params)
          rut_cliente = params[:buscador_rut_cliente].split('-')
          @cliente_acoma.run_cliente = rut_cliente[0]
          @cliente_acoma.dv_cliente = rut_cliente[1]
          @cliente_acoma.user = current_user
          @cliente_acoma.save!
          asocia_cliente_despacho(@cliente_acoma)
          format.html { redirect_to @cliente_acoma, notice: 'Cliente acoma ha sido actualizado correctamente.' }
          format.js
        else
          format.html { render action: 'edit' }
          format.js
        end
      end
    else
     @cliente_acoma = ClienteAcoma.new(cliente_acoma_params)
     rut_cliente = params[:buscador_rut_cliente].split('-')
     @cliente_acoma.user = current_user
     @cliente_acoma.run_cliente = rut_cliente[0]
     @cliente_acoma.dv_cliente = rut_cliente[1]

     respond_to do |format|
      if @cliente_acoma.save
        asocia_cliente_despacho(@cliente_acoma)
        format.html { redirect_to @cliente_acoma, notice: 'Cliente acoma ha sido creado correctamente.' }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
     end
    end
  end

  def buscardor_autocomplete
    term = params[:term]
    @find = ClienteAcoma.select("concat(run_cliente,'-',dv_cliente) as value, run_cliente, nombres_cliente, id, apellidos_cliente, dv_cliente, concat(run_cliente,'-',dv_cliente) as rut_cliente ").where("run_cliente LIKE ?", "%#{term}%").limit(10)
    respond_to do |format|
      format.json { render :json => @find.to_json }
    end
  end

  # DELETE /cliente_acomas/1
  # DELETE /cliente_acomas/1.json
  def destroy
    @cliente_acoma.destroy
    respond_to do |format|
      format.html { redirect_to cliente_acomas_url }
      format.js
    end
  end
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_cliente_acoma
        @cliente_acoma = ClienteAcoma.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def cliente_acoma_params

        params.require(:cliente_acoma).permit(:nombres_cliente, :apellidos_cliente)

      end

      def asocia_cliente_despacho(cliente)
        distpach = SaleDistpach.find(params[:id_sale_distpach])
        distpach.cliente_acoma = cliente
        distpach.save!
      end
end
