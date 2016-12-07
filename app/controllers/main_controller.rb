class MainController < ApplicationController
  def index
    @sale = Sale.last_sale
  end
end
