class Users::RegistrationsController < Devise::RegistrationsController

  def edit
  end

  def update
    if @user.update(user_params)
      sign_in @user, bypass: true
      redirect_to root_path, success: 'Datos guardados correctamente.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :warehouse_id, :name 
    )
  end
end
