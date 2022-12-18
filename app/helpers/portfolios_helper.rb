module PortfoliosHelper
  include APIWrapper

  def prices(arr)
    unless arr.empty?
      BinanceRawData.new.ticker_price arr
    else
      []
    end

  end

  def profit(arr)
    u = Currency.find(arr.map { |x| x[0] })
                .map { |x| x.symbol }
                .select { |x| x != "USDT" }
                .map { |x| Pair.where("coin1 = 'USDT' and coin2 = :coin or coin1 = :coin and coin2 = 'USDT'", coin: x)
                               .map { |x| x.pair } }.flatten
    l = prices(u).map { |x|
      t = x["price"].to_f
      if (x["symbol"] =~ /USDT/) == 0
        t = 1.0 / t
      end
      { x["symbol"].gsub("USDT", "") => t }
    }
    e = arr.map { |x| { Currency.find(x[0]).symbol => x[1] } }.inject(&:merge)
    sum = 0
    l.each { |x| sum += e[x.keys[0]] * x[x.keys[0]] }
    # ((sum + e["BTC"].to_f) * prices(["BTCUSDT"])[0]["price"].to_f + e["USDT"].to_f - 1_000_000) / 1_000_0
    (sum + e["USDT"].to_f - 1_000_000) / 1_000_0
  end
end
