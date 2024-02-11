# frozen_string_literal: true

class AuctionDecorator
  attr_reader :auction
  def self.decorated_scope(auctions)
    auctions.map do |auction|
      new(auction)
    end
  end
  def initialize(auction)
    @auction = auction
  end

  delegate_missing_to :auction

  def winner
    auction.winner&.name
  end

  def winner_bid_amount
    return unless auction.completed?
    if auction.bid_type == "max_win"
      max_bid&.amount
    else
      auction.bids.where(user: winner).sum(:amount)
    end
  end

  def total_donated
    return if auction.bid_type == "max_win"
    auction.bids.sum(:amount)
  end

  def max_bid_amount
    max_bid&.amount
  end

  def max_bid_user_name
    max_bid&.user&.name
  end

  def status
    auction.status.titleize
  end

  private

  def max_bid
    @_max_bit ||= auction.bids.max_by { |bid| bid.amount }
  end
end
