class Users::RegistrationsController < Devise::RegistrationsController
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
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
          redirect_to root_path, success: "Usuario actualizado satisfactoriamente."
      else
          render :edit, danger: "Ha ocurrido un error al ingresar los datos." 
      end
  end

  def create
    @user = User.new(user_params)
    if @user.save
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