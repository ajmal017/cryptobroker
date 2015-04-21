require_relative 'entity'

class Cryptobroker::API::Cexio::Ticker < Cryptobroker::API::Cexio::Entity
  attr_reader :timestamp, :bid, :ask, :last

  def initialize(raw_ticker)
    set_attrs raw_ticker, timestamp: 'timestamp', bid: 'bid', ask: 'ask', last: 'last'
    convert_attrs timestamp: :time, bid: :big_decimal, ask: :big_decimal, last: :big_decimal
  rescue
    raise Cryptobroker::API::Cexio::ResponseError
  end

  def spread
    ask - bid
  end
end