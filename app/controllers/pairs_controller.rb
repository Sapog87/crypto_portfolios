class PairsController < ApplicationController
  include PairsHelper

  before_action :set_pair, only: %i[ show buy sell ]
  before_action :set_currency, only: %i[ show buy sell ]
  before_action :set_coin1, only: %i[ buy sell ]
  before_action :set_coin2, only: %i[ buy sell ]
  before_action :set_price, only: %i[ show buy sell ]
  before_action :set_portfolio

  def index
    @pagy, @pairs = pagy(Pair, items: 10)
  end

  def show
  end

  def buy
    balance = Deal.where(portfolio_id: @portfolio.id, currency_id: @coin2.id).sum(:amount)
    value = (pair_params["amount"].to_f) * @price.to_f
    if value <= 0 or balance > value
      Deal.create(amount: pair_params["amount"], portfolio_id: @portfolio.id, currency_id: @coin1.id)
      Deal.create(amount: -value, portfolio_id: @portfolio.id, currency_id: @coin2.id)
      redirect_to portfolios_path
    else
      # redirect_to "/currencies/" + params[:currency_id].to_s + "/pairs/" + params[:id].to_s, notice: "Wrong amount"
      redirect_to currency_pair_path(@currency, @pair), notice: "Wrong amount"
    end
  end

  def sell
    balance = Deal.where(portfolio_id: @portfolio.id, currency_id: @coin1.id).sum(:amount)
    value = pair_params["amount"].to_f
    if value <= 0 or balance >= value
      Deal.create(amount: -value, portfolio_id: @portfolio.id, currency_id: @coin1.id)
      Deal.create(amount: value * @price.to_f, portfolio_id: @portfolio.id, currency_id: @coin2.id)
      redirect_to portfolios_path
    else
      # redirect_to "/currencies/" + params[:currency_id].to_s + "/pairs/" + params[:id].to_s, notice: "Wrong amount"
      redirect_to currency_pair_path(@currency, @pair), notice: "Wrong amount"
    end
  end

  private

  def set_price
    @price = prices(@pair.pair)["price"]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pair
    @pair = Pair.find(params[:id])
  end

  def set_portfolio
    unless @user.nil?
      @portfolio = Portfolio.find_by_user_id @user.id
    end
  end

  def set_currency
    @currency = Currency.find(params[:currency_id])
  end

  def set_coin1
    @coin1 = Currency.find_by symbol: @pair.coin1
  end

  def set_coin2
    @coin2 = Currency.find_by symbol: @pair.coin2
  end

  # Only allow a list of trusted parameters through.
  def pair_params
    params.require(:pair).permit(:amount)
  end
end
