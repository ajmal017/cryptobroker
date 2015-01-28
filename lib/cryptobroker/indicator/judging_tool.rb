require_relative 'macd'
require_relative 'macd_with_dema'
require_relative 'macd_on_dema'
require_relative 'filtered_macd'
require_relative 'filtered_macd_with_dema'
require_relative 'dema'
require_relative 'filtered_dema'
require_relative 'random'
require_relative '../statistics'
require_relative '../logging'

module Cryptobroker::Indicator
  class JudgingTool
    extend Cryptobroker::Statistics
    include Cryptobroker::Logging

    HOUR_TF = 60 * 60

    def initialize(timeframes, min_sample_bars)
      @timeframes = timeframes
      @prices = [:median, :weighted]
      @min_sample_bars = min_sample_bars
      @indicators = [
      ->(b, p) { MACD.new b, p, 12, 26, 9 },
      ->(b, p) { MACD.new b, p, 5, 35, 5 },
      ->(b, p) { MACD.new b, p, 13, 17, 9 },
      ->(b, p) { FilteredMACD.new b, p, 12, 26, 9 },
      ->(b, p) { FilteredMACD.new b, p, 5, 35, 5 },
      ->(b, p) { FilteredMACD.new b, p, 16, 97, 2 },
      ->(b, p) { FilteredMACD.new b, p, 13, 17, 9 },
      ->(b, p) { DEMA.new b, p, 21, 55 },
      ->(b, p) { DEMA.new b, p, 50, 100 },
      ->(b, p) { FilteredDEMA.new b, p, 21, 55 },
      ->(b, p) { FilteredDEMA.new b, p, 50, 100 },
      ->(b, p) { MACDWithDEMA.new b, p, 12, 26, 9 },
      ->(b, p) { MACDWithDEMA.new b, p, 5, 35, 5 },
      ->(b, p) { MACDWithDEMA.new b, p, 13, 17, 9 },
      ->(b, p) { FilteredMACDWithDEMA.new b, p, 12, 26, 9 },
      ->(b, p) { FilteredMACDWithDEMA.new b, p, 5, 35, 5 },
      ->(b, p) { FilteredMACDWithDEMA.new b, p, 13, 17, 9 },
      ->(b, p) { FilteredMACDWithDEMA.new b, p, 16, 97, 2 },
      ->(b, p) { MACDOnDEMA.new b, p, 12, 26, 9, 8 },
      ->(b, p) { MACDOnDEMA.new b, p, 5, 35, 5, 8 },
      ->(b, p) { MACDOnDEMA.new b, p, 13, 17, 9, 8 },
      ->(b, p) { MACDOnDEMA.new b, p, 16, 97, 2, 8 },
      ->(b, p) { MACDOnDEMA.new b, p, 12, 26, 9, 5 },
      ->(b, p) { MACDOnDEMA.new b, p, 5, 35, 5, 5 },
      ->(b, p) { MACDOnDEMA.new b, p, 13, 17, 9, 5 },
      ->(b, p) { Random.new b, p },
      ]
      @prng = ::Random.new
    end

    protected

    def rand(*args)
      @prng.rand *args
    end

    def ohlcv(trade, timeframe, starts = nil, ends = nil)
      Cryptobroker::OHLCV.create trade, timeframe, starts, ends, false
    end
  end
end