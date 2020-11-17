class CustomerQuotesController < ApplicationController
  before_action :set_customer_quote, only: [:show, :edit, :update, :destroy]

  def index
    if params[:start_date] && params[:end_date]
      @customer_quotes = CustomerQuote.all
      @customer_quotes = @customer_quotes.where(created_at: params[:start_date].to_date.beginning_of_day..params[:end_date].to_date.end_of_day) unless params[:start_date].blank? || params[:end_date].blank?
      @customer_quotes = @customer_quotes.where(user_id: params[:user][:id]) unless params[:user][:id].blank?
      @customer_quotes = @customer_quotes.paginate(:page => params[:page], :per_page => 20)
    else
      @customer_quotes = CustomerQuote.all.paginate(:page => params[:page], :per_page => 20)
    end
    @customer_quote = CustomerQuote.new
    @cliente_acoma = ClienteAcoma.new
  end

  def show
    respond_to do |format|
      if @customer_quote.save
        format.html
        format.js
      else
        format.html
        format.js
      end
    end
  end

  def new
    @customer_quote = CustomerQuote.new
  end

  def edit
  end

  # POST /customer_quotes
  # POST /customer_quotes.js
  def create
    @customer_quote = CustomerQuote.new(customer_quote_params)

    respond_to do |format|
      if @customer_quote.save
        format.html { redirect_to @customer_quote, notice: 'Customer ha sido creado correctamente.' }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end
  # PUT /customer_quotes/1
  # PUT /customer_quotes/1.json
  def update
    respond_to do |format|
      if @customer_quote.update(customer_quote_params)
        format.html { redirect_to @customer_quote, notice: 'Customer ha sido actualizado correctamente.' }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  # DELETE /customer_quotes/1
  # DELETE /customer_quotes/1.json
  def destroy
    @customer_quote.destroy
    respond_to do |format|
      format.html { redirect_to customer_quotes_url }
      format.js
    end
  end
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer_quote
        @customer_quote = CustomerQuote.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def customer_quote_params

        params.require(:customer_quote).permit(:email, :full_name, :rut, :address, :total_quote, :user_id)

      end
end
