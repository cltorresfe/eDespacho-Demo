class MainController < ApplicationController
	before_action :authenticate_user!
  def index
    @sale = Sale.last_sale
  end
end
