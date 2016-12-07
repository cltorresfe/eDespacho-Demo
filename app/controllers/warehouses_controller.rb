class WarehousesController < ApplicationController
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @warehouses = Warehouse.all
  end

  def show
  end

  def new
    @warehouse = Warehouse.new

  end

  def edit
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, success: 'Bodega ha sido creada satisfactoriamente.' }
        format.json { render :show, status: :created, location: @warehouse }
      else
        format.html { render :new,  danger: 'No se pudieron guardar los cambios'  }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html { redirect_to @warehouse, success: 'Bodega ha sido actualizada satisfactoriamente.' }
        format.json { render :show, status: :ok, location: @warehouse }
      else
        format.html { render :edit, danger: 'No se pudieron guardar los cambios.'  }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @warehouse.destroy
  end

  private
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    def warehouse_params
      params.require(:warehouse).permit(:name, :address)
    end
end
