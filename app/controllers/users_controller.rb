class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def show
      @user = User.find_by_id(params[:id])
    end

    def new
        @user = User.new
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @store = Store.find(params[:user][:warehouse_id])
        @warehouse = Warehouse.find_by(id: params[:user][:warehouse_id])
        unless @warehouse.present?
          @warehouse = Warehouse.new
          @warehouse.id = @store.CodBode
          @warehouse.name = @store.DesBode
          @warehouse.address = @store.Direc
          @warehouse.save!
        end
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          bypass_sign_in(@user)
          redirect_to root_path, success: "Usuario actualizado satisfactoriamente."
        else
            render :edit, danger: "Ha ocurrido un error al ingresar los datos." 
        end
    end

    def create
      @store = Store.find(params[:user][:warehouse_id])
      @warehouse = Warehouse.find_by(id: params[:user][:warehouse_id])
      unless @warehouse.present?
        @warehouse = Warehouse.new
        @warehouse.id = @store.CodBode
        @warehouse.name = @store.DesBode
        @warehouse.address = @store.Direc
        @warehouse.save!
      end
      @user = User.new(user_params)
      if @user.save
        bypass_sign_in(current_user)
        redirect_to root_path, success: "Usuario Ingresado Satisfactoriamente." 
      else
        render :new, danger: "Ha ocurrido un error al ingresar los datos." 
      end
    end

	private

	def user_params
	  params.require(:user).permit( :email, :password, :password_confirmation, :warehouse_id, :admin)
	end
end