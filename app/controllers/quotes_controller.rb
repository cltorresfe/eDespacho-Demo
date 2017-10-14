class QuotesController < ApplicationController
	before_action :authenticate_user!
  def carro_cotizacion
  	@cotizaciones = Quote.where(user: current_user)
  end
end