class MainController < ApplicationController
  def index
  	@sellers = Seller.all
    @sale = Sale.last_sale
  end
end
