# frozen_string_literal: true

class Auctions::BidsController < ApplicationController
  before_action :set_auction
  attr_reader :auction

  def index
    @bids = auction.bids.newest_first.preload(:user)
  end

  def create
    auction.bids.create!(user: current_user, amount: params[:amount])
    render json: {}, status: 201
  end

  private

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end
end
