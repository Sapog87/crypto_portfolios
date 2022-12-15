class DealsController < ApplicationController

  # GET /deals
  def index
    @portfolio = Portfolio.find params[:portfolio_id]
    if @portfolio.private and @portfolio.user_id != @user.id
      redirect_to user_path(@user), alert: "Private portfolio"
    else
      @deals = Deal.where(portfolio_id: params[:portfolio_id])
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def deal_params
    params.require(:deal).permit(:price, :amount, :portfolio_id, :currency_id)
  end
end
