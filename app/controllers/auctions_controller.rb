# frozen_string_literal: true

class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all.preload(bids: :user)
  end

  def show
    @auction = Auction.find(params[:id])
  end
end
