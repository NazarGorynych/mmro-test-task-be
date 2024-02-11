# frozen_string_literal: true

class AuctionsController < ApplicationController
  included AuctionFiltersConcern

  def index
    @auctions = Auction.all.preload(bids: :user)
    filter_auction_scope
    @auctions.preload(:winner, bids: :user)
  end

  def show
    @auction = Auction.find(params[:id])
  end
end
