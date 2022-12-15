class CurrenciesController < ApplicationController
  include CurrenciesHelper

  before_action :set_currency, only: %i[ show ]

  def index
    p params
    if params[:search].nil?
      @pagy, @currencies = pagy(Currency, items: 10)
    else
      symbol = params[:search].upcase
      @pagy, @currencies = pagy(Currency.where("symbol like :symbol", { symbol: "%#{symbol}%" }), items: 10)
    end
  end

  def show
    @currency = Currency.find(params[:id])
    @pagy, @pairs = pagy(Pair.where("coin1 = :coin or coin2 = :coin", { "coin": "#{@currency.symbol}" }), items: 10)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_currency
    @currency = Currency.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def currency_params
    params.require(:currency).permit(:symbol)
  end

end
