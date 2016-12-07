class SearchController < ApplicationController
  def search
    @sale = Sale.folio_sale(params[:search][:q])
  end
end
