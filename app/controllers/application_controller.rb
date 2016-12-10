class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:index, :show]

  add_flash_types :danger, :info, :warning, :success, :notice, :info

end
