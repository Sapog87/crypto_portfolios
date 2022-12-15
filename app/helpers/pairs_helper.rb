module PairsHelper
  include APIWrapper

  def prices(arr)
    BinanceRawData.new.ticker_price arr
  end
end
