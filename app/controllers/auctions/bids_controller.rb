# frozen_string_literal: true

class Auctions::BidsController < ApplicationController
  before_action :set_auction
  attr_reader :auction
  after_action :update_chanel, on: :create

  def index
    @bids = auction.bids.newest_first.preload(:user)
  end

  def create
    @bid = auction.bids.create!(user: current_user, amount: params[:amount])
    render json: {}, status: 201
  end

  private

  def update_chanel
    ActionCable.server.broadcast("AuctionBidsChannel#{params[:auction_id]}", {bid: { amount: @bid.amount, created_at: @bid.created_at, max_by_user: @bid.max_by_user }, author: { name: current_user.name, email: current_user.email, avatar: url_for(current_user.avatar) }})
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end
end
