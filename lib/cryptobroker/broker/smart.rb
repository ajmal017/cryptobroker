require 'thread'
require_relative '../logging'
require_relative 'smart/trader'

module Cryptobroker::Broker
  class Smart
    include Cryptobroker::Logging

    CONCURRENCY_DELAY = 0.3

    def initialize(conf, api, investor)
      super()
      @trader = Trader.new conf, api, investor
      @signals = Queue.new
      @manager = Thread.new do
        loop do
          signal = @signals.pop
          sleep CONCURRENCY_DELAY
          begin
            loop { signal = @signals.pop true }
          rescue ThreadError
            @trader.handle_order *signal
          end
        end
      end
      @manager.abort_on_exception = true
    end

    def buy(timestamp, params)
      @signals.push [:buy, timestamp, params[:price]]
    end

    def sell(timestamp, params)
      @signals.push [:sell, timestamp, params[:price]]
    end

    def cancel
      @trader.cancel
    end
  end
end
