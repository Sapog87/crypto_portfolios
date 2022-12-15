class PortfoliosController < ApplicationController
  include PortfoliosHelper
  before_action :set_portfolio, only: %i[ index update ]

  def index
    redirect_to portfolio_path(@portfolio)
  end

  def show
    @portfolio = Portfolio.find(params[:id])
    if @portfolio.private and @portfolio.user_id != @user.id
      redirect_to user_path, alert: "Private portfolio"
    else
      coins_sums = Deal.where(portfolio_id: @portfolio.id)
                       .group("currency_id")
                       .having("sum(amount) > 0")
                       .sum(:amount)
      @deals = coins_sums.map { |x| { Currency.find(x[0]).symbol => x[1] } }
      @profit = profit(coins_sums)
    end
  end

  def update
    @portfolio.private = !@portfolio.private
    @portfolio.save
    redirect_to @portfolio
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_portfolio
    if @user.nil?
      redirect_to new_session_path
    else
      @portfolio = Portfolio.find_by_user_id(@user.id)
    end
  end

  # Only allow a list of trusted parameters through.
  def portfolio_params
    params.require(:portfolio).permit(:private, :money, :user_id)
  end
end
