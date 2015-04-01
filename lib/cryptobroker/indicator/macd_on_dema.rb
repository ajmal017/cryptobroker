require_relative 'histogram_based'

module Cryptobroker::Indicator
  class MACDOnDEMA
    include HistogramBased

    def initialize(conf = {price: 'median', fast: 12, slow: 26, signal: 9, dema: 8})
      super conf
      @macd = Macd.new conf[:fast], conf[:slow], conf[:signal]
      @dema = Dema.new conf[:dema]
    end

    def name
      "MACD(#{@macd.slow_period},#{@macd.fast_period},#{@macd.signal_period}) on DEMA(#{@dema.time_period})"
    end

    def histogram(chart)
      price = price chart
      price = @dema.run price
      ridx = price.rindex { |i| !i.nil? }
      hist = []
      unless ridx.nil?
        price.pop(price.size - ridx - 1)
        hist = @macd.run(price)[:out_macd_hist]
      end
      hist.fill(nil, hist.size, chart.size - hist.size)
      shift_nils hist
    end
  end
end