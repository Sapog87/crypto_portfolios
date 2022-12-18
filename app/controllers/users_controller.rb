class UsersController < ApplicationController
  before_action :authorized, except: :show
  before_action :set_user, only: %i[ show ]

  def index
    redirect_to user_path(current_user)
  end

  def show
    @portfolio = Portfolio.find_by_user_id @user.id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    ActiveRecord::Base.transaction do
      if @user.save
        @portfolio = Portfolio.create(private: true, user_id: @user.id)
        @currency = Currency.find_by symbol: "USDT"
        Deal.create(amount: 1000000, portfolio_id: @portfolio.id, currency_id: @currency.id)
        session[:user_id] = @user.id
        redirect_to @user, notice: "Account was successfully created."
      else
        render new_user_path, status: :unprocessable_entity
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
